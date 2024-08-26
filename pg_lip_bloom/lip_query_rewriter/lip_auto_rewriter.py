PATH = '/mnt/pg_lip_bloom/runtime_eval/'
import sys
sys.path.append(PATH)
from core.cardinality_estimation_quality.cardinality_estimation_quality import *
from treelib import Node, Tree
from tqdm import tqdm
import numpy as np
import re

LIP_OPTIMIZATION_SEL_THRESHOLD = 0.05
LIP_OPTIMIZATION_SEL_THRESHOLD_FACT = 0.0001
LIP_OPTIMIZATION_SEL_THRESHOLD_DIM = 0.05
INDEX_AVAILABILITY = {}

class PostgreConnector:

    def __init__(self,):
        server='localhost' 
        username='postgres'
        password='postgres'
        # db_name='stack'
        db_name='imdbload'

        self.db_url = f"host={server} port=5432 user={username} dbname={db_name} password={password} options='-c statement_timeout={6000000}' "
        db = self.db_url.format(db_name)
        self.PG = Postgres(db)
        self.parse_index_availability()

    def get_plan(self, sql_str, execute=False):
        # assert 'explain' not in sql_str.lower()
        # print(sql_str)
        return self.PG.explain(sql_str, execute=execute)[0][0][0]["Plan"]

    def get_cardinality(self, sql_str):
        plan = self.get_plan(sql_str)
        return plan["Plan Rows"]

    def parse_index_availability(self, ):
        sql = """
        SELECT
            tablename,
            indexdef
        FROM
            pg_indexes
        WHERE
            schemaname = 'public'
        ORDER BY
            tablename,
            indexname;
        """
        conn = psycopg2.connect(self.db_url)
        conn.set_client_encoding('UTF8')
        cur = conn.cursor()
        cur.execute(sql)
        index_defs = cur.fetchall()
        conn.close()
        for index in index_defs:
            table = index[0]
            on_attrs = index[1].split('(')[1].split(')')[0].split(',')
            if table not in INDEX_AVAILABILITY:
                INDEX_AVAILABILITY[table] = []
            INDEX_AVAILABILITY[table].append(set([s.replace(' ', '') for s in on_attrs]))

def is_join_node(node):
    if 'Nested Loop' in node.lip_info['Type'] or 'Hash Join' in node.lip_info['Type'] or 'Merge Join' in node.lip_info['Type']:
        return True
    else:
        return False

def is_scan_node(node):
    return 'scan' in node.lip_info['Type'].lower()

def is_operator(node):
    return is_join_node(node) or is_scan_node(node)

def parse_join_cond(join_cond):
    join_cond = join_cond.replace('(', '').replace(')', '').replace(' ', '')
    cond1 = join_cond.split('=')[0]
    cond2 = join_cond.split('=')[1]
    return cond1.split('.')[0], cond1.split('.')[1], cond2.split('.')[0], cond2.split('.')[1]

def normalize_sql(sql):
    new_sql = '' 
    for l in sql.split('\n'):
        new_sql += ' ' + l + ' \n' 
    new_sql = new_sql.replace(' where ', ' WHERE ')
    new_sql = new_sql.replace(' from ', ' FROM ')
    new_sql = new_sql.replace(' select ', ' SELECT ')
    new_sql = new_sql.replace(' and ', ' AND ')
    if ';' not in new_sql:
        new_sql = new_sql + ';'
    return new_sql

node_cnt = 0
def form_plan_tree(plan_dict):
    plan_tree = Tree()
    global node_cnt 
    node_cnt = 0
    predicate_nodes = []
    table_depth = {}

    def dfs(root, plan_d, lvl):
        global node_cnt
        current_node_id = plan_d['Node Type'] + f'_{node_cnt}'
        plan_tree.create_node(current_node_id, current_node_id, parent=root.identifier)
        current_node = plan_tree.get_node(current_node_id)
        current_node.lip_info = {"Type": plan_d['Node Type'], 'Depth': lvl}
        current_node.parent = root

        if 'Filter' in plan_d:
            predicate_nodes.append(current_node)
            current_node.lip_info['Filter'] = plan_d['Filter']
        if 'Index Cond' in plan_d:
            current_node.lip_info['Index Cond'] = plan_d['Index Cond']
        if 'Join Filter' in plan_d:
            current_node.lip_info['Join Filter'] = plan_d['Join Filter']
        if 'Merge Cond' in plan_d:
            current_node.lip_info['Join Filter'] = plan_d['Merge Cond']

        if 'Scan' in plan_d['Node Type']:
            current_node.lip_info['Relation Name'] = plan_d['Relation Name']
            current_node.lip_info['Alias'] = plan_d['Alias']
            table_depth[plan_d['Alias']] = lvl

        if 'Actual Rows' in plan_d:
            current_node.lip_info['Actual Rows'] = plan_d['Actual Rows']

        node_cnt += 1
        if 'Plans' in plan_d:
            for p in plan_d['Plans']:
                dfs(current_node, p, lvl+1 if is_operator(current_node) else lvl)

    plan_tree.create_node('root', 'root', parent=None)
    root = plan_tree.get_node('root')
    root.parent = None
    dfs(root, plan_dict, 0)
    return plan_tree, predicate_nodes, table_depth

def construct_lip_filters(predicate_nodes):
    LIP_filters = {}
    for n in predicate_nodes: 
        parent = n.parent
        while parent and not is_join_node(parent):
            parent = parent.parent
        if parent is not None:
            conds = []
            if 'Join Filter' in parent.lip_info:
                conds += parent.lip_info['Join Filter'].strip(')').strip('(').split('AND')
            if 'Index Cond' in n.lip_info:
                index_conds = n.lip_info['Index Cond'].strip(')').strip('(').split('AND')
                for idx, cond in enumerate(index_conds):
                    if '.' not in cond.split('=')[0]:
                        index_conds[idx] = n.lip_info['Alias'] + '.' + index_conds[idx]
                conds += index_conds
            
            for c in conds:
                alias1, attr1, alias2, attr2 = parse_join_cond(c)
                if alias2 == n.lip_info['Alias']:
                    alias1, attr1, alias2, attr2 = alias2, attr2, alias1, attr1
                
                if alias2 not in LIP_filters:
                    LIP_filters[alias2] = []
                LIP_filters[alias2].append({
                    'from_alias': n.lip_info['Alias'],
                    'from_relation': n.lip_info['Relation Name'],
                    'from_filter': n.lip_info['Filter'],
                    'from_depth':  n.lip_info['Depth'],
                    'from_attr': attr1,
                    'to_attr': attr2,
                    'to_alias': alias2,
                    'join_node': parent,
                    'from_node': n,
                    'disabled': False
                })
    return LIP_filters

def lip_optimization(LIP_filters, table_depth, conn=None):
    for to_alias in LIP_filters:
        for bf in LIP_filters[to_alias]:
            # at least two levels away 
            if np.abs(bf['from_depth'] - table_depth[to_alias]) < 1:
                bf['disabled'] = True
            # cardinality 
            if conn is not None:
                cardinality_sql = f"SELECT * FROM {bf['from_relation']} as {bf['from_alias']} WHERE {bf['from_filter']};"
                total_cardinality = f"SELECT * FROM {bf['from_relation']} as {bf['from_alias']};"
                sel = conn.get_cardinality(cardinality_sql) / conn.get_cardinality(total_cardinality)
                if sel > LIP_OPTIMIZATION_SEL_THRESHOLD:
                    bf['disabled'] = True
    return LIP_filters

def aja_optimization(plan_tree):

    root = plan_tree.children('root')[0]
    assert 'Actual Rows' in root.lip_info, "Should execute the query before applying AJA."

    def aja(node):
        if node is None:
            return
        children = plan_tree.children(node.identifier)
        if is_scan_node(node):
            # if wrong index type
            if 'Index' in node.lip_info['Type'] and 'Index Cond' in node.lip_info:
                input_str = node.lip_info['Index Cond']
                # print("Index scan on ", node.lip_info['Relation Name'])
                attr_set = set(re.findall(r'\b\w+\b(?=\s*=[^=])', input_str))
                # print("Index scan on ", attr_set)
                found = False
                for idx_attrs in INDEX_AVAILABILITY[node.lip_info['Relation Name']]:
                    # print("searching: ", idx_attrs)
                    if idx_attrs == attr_set:
                        found = True
                        break
                    elif attr_set.issubset(idx_attrs) and len(idx_attrs) - len(attr_set) <= 2 and node.lip_info['Relation Name']!='post_link':
                        # we bear at most one additional attribute in the index if the index is multi-dim
                        # due to the performance of high dimensional b-tree index 
                        found = True
                        break
                if not found:
                    # print("Switching to ", 'Seq Scan')
                    node.lip_info['Type'] = 'Seq Scan'

            return node.lip_info['Type'], node.lip_info['Actual Rows']
        elif is_join_node(node):
            assert len(children) == 2
            left_type, left_size = aja(children[0])
            right_type, right_size = aja(children[1])
            if 'Index' in right_type and ('Nest' in node.lip_info['Type'] or 'Merge' in node.lip_info['Type']) and left_size > 500000:
                # print(f"Switching from {node.lip_info['Type']} to Hash Join")
                node.lip_info['Type'] = 'Hash Join'
            if 'Seq' in right_type and ('Nest' in node.lip_info['Type'] or 'Merge' in node.lip_info['Type']) and left_size > 1:
                # print(f"Switching from {node.lip_info['Type']} to Hash Join")
                node.lip_info['Type'] = 'Hash Join'
            if 'Scan' not in right_type and 'Scan' not in left_type and 'Hash' not in node.lip_info['Type']:
                # print(f"Switching from {node.lip_info['Type']} to Hash Join")
                node.lip_info['Type'] = 'Hash Join'

            return node.lip_info['Type'], node.lip_info['Actual Rows']
        else:
            return aja(children[0])
    
    aja(root)
    return plan_tree


def reconstruct_pg_hint(plan_tree, LIP_filters):
    
    # reconstruct pg_hint_plan
    pg_hint_plans = []
    root = plan_tree.children('root')[0]

    def get_physical_op_plan(node):
        if node is None:
            return []
        children = plan_tree.children(node.identifier)
        if is_join_node(node):
            alias = []
            for child_node in children:
                alias += get_physical_op_plan(child_node)
            if 'Nested Loop' in node.lip_info['Type']:
                pg_hint_plans.append('NestLoop(' + ' '.join(alias) + ')')
            elif 'Hash Join' in node.lip_info['Type']:
                pg_hint_plans.append('HashJoin(' + ' '.join(alias) + ')')
            elif 'Merge Join' in node.lip_info['Type']:
                pg_hint_plans.append('MergeJoin(' + ' '.join(alias) + ')')            
            return alias
        elif is_scan_node(node):
            alias = [node.lip_info['Alias']]
            pg_hint_plans.append(node.lip_info['Type'].replace('Only', '').replace(' ', '') + '(' + alias[0] + ')')
            return alias
        else:
            alias = []
            for child_node in children:
                alias += get_physical_op_plan(child_node)
            return alias

    def get_jo_plan(node):
        if node is None:
            return ''
        children = plan_tree.children(node.identifier)

        if is_scan_node(node):
            return node.lip_info['Alias']
        elif is_join_node(node):
            jo_plans = []
            for child_node in children:
                jo_plans.append(get_jo_plan(child_node))
            return '(' + ' '.join(jo_plans) + ')'
        else:
            return get_jo_plan(children[0])
    
    get_physical_op_plan(root)
    pg_hint_plans = sorted(pg_hint_plans, key=lambda x: - len(x))
    pg_hint_plan = '/*+\n' + '\n'.join(pg_hint_plans) + f'\nLeading({get_jo_plan(root)})\n*/'
    return pg_hint_plan
    
def reconstruct_lip_sql(original_sql, pg_hint_plan, LIP_filters):
    full_lip_sql = []

    # creation of the bloom filters
    total_bloom_cnt = 0
    from_lip_filters = {}
    for target_alias in LIP_filters:
        for f in LIP_filters[target_alias]:
            if not f['disabled']:
                total_bloom_cnt += 1
                if f['from_alias'] not in from_lip_filters:
                    from_lip_filters[f['from_alias']] = []
                from_lip_filters[f['from_alias']].append(
                    {
                        'from_alias': f['from_alias'],
                        'from_relation': f['from_relation'],
                        'from_filter': f['from_filter'],
                        'from_attr': f['from_attr'], 
                        'to_attr': f['to_attr'],
                        'to_alias': target_alias
                    }
                )
    
    full_lip_sql.append('SELECT pg_lip_bloom_set_dynamic(2);')
    full_lip_sql.append(f'SELECT pg_lip_bloom_init({total_bloom_cnt});')
    
    bf_ids = {}
    bf_id = 0

    for i, from_alias in enumerate(from_lip_filters):
        constuction = []
        filters = []
        for bf in from_lip_filters[from_alias]:
            constuction.append(f"sum(pg_lip_bloom_add({bf_id}, {from_alias}.{bf['from_attr']}))")
            filters.append(bf['from_filter'])
            # bf_ids[f"{from_alias},{bf['to_alias']}"] = (bf_id, bf['to_attr'])
            if bf['to_alias'] not in bf_ids:
                bf_ids[bf['to_alias']] = []
            bf_ids[bf['to_alias']].append((bf_id, bf['to_attr']))
            bf_id += 1
        
        lip_construct = f"""SELECT {", ".join(constuction)} FROM {bf['from_relation']} AS {from_alias} 
        WHERE {" AND ".join(filters)};"""
        full_lip_sql.append(lip_construct)
    
    full_lip_sql.append('\n')
    full_lip_sql.append(pg_hint_plan)

    # full_lip_sql.append(original_sql)

    select_clause = original_sql.split('FROM')[0].strip('\n')
    from_clause = original_sql.split('FROM')[1].split('WHERE')[0]
    condition_clause = ' WHERE '.join(original_sql.split('WHERE')[1:])

    from_clauses = from_clause.split(',')
    lip_from_clauses = []
    for c in from_clauses:
        c = c.replace('\n', '').strip(' ')
        if 'as' in c.lower():
            to_alias = c.lower().split(' as ')[-1].replace(' ', '')
        elif ' ' in c.lower():
            to_alias = c.lower().split(' ')[-1].replace(' ', '')
        else:
            to_alias = c.lower()

        if to_alias in bf_ids:
            lip_probes = []
            for bf in bf_ids[to_alias]:
                lip_probes.append(f"pg_lip_bloom_probe({bf[0]}, {to_alias}.{bf[1]}) ")
            lip_from_clauses.append(
f"""(
    SELECT * FROM {c}
    WHERE \n{' AND '.join(lip_probes)}
) AS {to_alias}"""
            )
        else:
            lip_from_clauses.append(c)

    full_lip_sql.append(select_clause + "\nFROM ")
    full_lip_sql.append(',\n'.join(lip_from_clauses)+ "\nWHERE ")
    full_lip_sql.append(condition_clause)
    return '\n'.join(full_lip_sql)

    
def LIP_AJA_rewrite(sql, lip_opt=True, aja_opt=True, evaluate=False):
    test_query = normalize_sql(sql)

    conn = PostgreConnector()
    plan_dict = conn.get_plan(test_query, aja_opt)
    plan_tree, predicate_nodes, table_depth = form_plan_tree(plan_dict)
    LIP_filters = construct_lip_filters(predicate_nodes)
    
    if lip_opt:
        LIP_filters = lip_optimization(LIP_filters, table_depth, conn)
    if aja_opt:
        plan_tree = aja_optimization(plan_tree)
    
    pg_hint_plan = reconstruct_pg_hint(plan_tree, LIP_filters)
    full_sql = reconstruct_lip_sql(test_query, pg_hint_plan, LIP_filters)

    return full_sql


if __name__ == "__main__":

    import os
    queries_dir = '/mnt/pg_lip_bloom/queries/job/'
    
    all_files = sorted([s for s in os.listdir(queries_dir) if '.sql' in s])
    
    os.system(f"mkdir {os.path.join(queries_dir, 'lip_aja_auto_rewrite/')}")
    for sql_file in tqdm(all_files):
        print(sql_file)
        with open(os.path.join(queries_dir, sql_file), encoding='utf8') as f, open(os.path.join(queries_dir, 'lip_aja_auto_rewrite', sql_file), 'w') as g:
            sql_str = f.read()
            rewriten = LIP_AJA_rewrite(sql_str, True, True,)
            # print(rewriten)
            g.write(rewriten)
        # break

    