# %load_ext autoreload
# %autoreload 2
PATH = '/mnt/adaptiveness_vs_learning/runtime_eval/'
import sys
sys.path.append(PATH)
from core.eval_Runtime import *



import sqlparse

def sql_formater(sql):
    return sqlparse.format(sql, reindent=True, keyword_case='upper')


engine_name = 'postgres'
db_name = 'imdbload'
query_dir = './all/'
run_queries = sorted([q for q in os.listdir(query_dir) if '.sql' in q])
multiple_runs = 3

pg_db = DB_instance(engine_name, db_name)
pg_ev = Runtime_Evaluator(pg_db, query_dir)
pg_ev.evaluate_queries(
    sql_dir=query_dir,
    sql_files=run_queries,
    save_json_file=f'./{engine_name}_{db_name}_runtimes.json', 
    rerun_finished=False,
    disable_op="mergejoin",
    disable_parallel=False,
    multiple_runs=multiple_runs,
    save_plan=False,
    timeout=6000
)