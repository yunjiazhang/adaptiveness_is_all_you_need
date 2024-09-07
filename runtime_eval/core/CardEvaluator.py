from .QueryEvaluator import *
import sqlparse
import numpy as np

class PostgresEstCardEvaluator(PostgresCEBQueryEvaluator):
    def __init__(self, 
                 db_config, 
                 query_directory, 
                 query_files=None, 
                 debug_mode=False,
                 ceb_file_name='stats_CEB_sub_queries_bayescard.txt'
                 ):
        super().__init__(db_config, query_directory, query_files, debug_mode, ceb_file_name)
        self.true_cardinality = {}
        self.est_cardinality = {}

    def _sql_formater(self, sql):
        return sqlparse.format(sql, reindent=True, keyword_case='upper')

    def load_ground_truth_cardinality(self, all_query_results_file='./stats_CEB.sql'):
        with open(all_query_results_file, 'r') as f:
            for qid, line in enumerate(f):
                card, _ = line.strip().split('||')
                self.true_cardinality[f'{qid+1}.sql'] = int(card)

    def get_est_cardinality(self, sql):
        sql = self._sql_formater(sql)
        if 'COUNT(*)' in sql:
            sql = sql.replace('COUNT(*)', '*')
        explained_sql_josn = self.explain_query(sql, execute=False)[0][0][0]
        est_card = explained_sql_josn['Plan']['Plan Rows']
        return est_card
    
    def evaluate_queries(self,
                         rerun_finished=False, 
                         sample_size=None):
        if self.query_log_file and os.path.exists(self.query_log_file):
            print(f"Loading query log from {self.query_log_file}...")
            with open(self.query_log_file, 'r') as infile:
                self.query_cards = json.load(infile)
        else:
            print(f"Initiating new query log...")
            self.query_cards = {}
        
        if self.query_files:
            all_queries = sorted(self.query_files)
        else:
            all_queries = sorted([q for q in os.listdir(self.query_directory)])

        if sample_size is not None:
            import random
            all_queries = random.sample(all_queries, sample_size)

        for qn, query_file in enumerate(all_queries):
            print(f"Explaining query {query_file} ({qn} / {len(all_queries)})...")
            query_path = os.path.join(self.query_directory, query_file)
            
            if not (query_file not in self.query_cards or rerun_finished):
                print(f"\tQuery {query_file} has already been evaluated. Skipping...")
                continue
            
            if os.path.isfile(query_path) and query_file.endswith('.sql'):
                with open(query_path, 'r') as file:
                    query = file.read()
                if self.debug_mode:
                    print(query)

                try:
                    estcard = self.get_est_cardinality(query)
                except Exception as e:
                    print(f"\tError explaining query {query_file}: {e}")
                    self.conn.rollback()
                    continue
                self.query_cards[query_file] = (self.true_cardinality[query_file], estcard)
            
            # Output the results to a JSON dictionary
            if qn % self.SAVE_FREQ == 0 or qn == len(all_queries) - 1:
                with open(self.query_log_file, 'w') as outfile:
                    json.dump(self.query_cards, outfile, indent=4)
        print(f"Finished explaining {len(all_queries)} queries.")
        
    def calculate_ave_q_error(self, ):
        q_errors = []
        for q in self.query_cards:
            true_card, est_card = self.query_cards[q]
            q_errors.append(max(
                est_card/ true_card,
                true_card / est_card
            ))
        q_errors = np.array(q_errors)
        return {
                "Min": np.min(q_errors), 
                "Max": np.max(q_errors), 
                "Avg": np.mean(q_errors), 
                "Median": np.median(q_errors),
                "90th": np.percentile(q_errors, 90),
                "99th": np.percentile(q_errors, 99),
            }

    def run(self, query_log_file='postgres-stats-est-card.json', rerun_finished=False, sample_size=None):
        self.query_log_file = query_log_file
        self.connect_to_db()
        self.load_ground_truth_cardinality(
            all_query_results_file='./stats_CEB.sql'
        )
        self.evaluate_queries(
            rerun_finished=rerun_finished,
            sample_size=sample_size

        )
        print(f"Measuring Q-error: {self.calculate_ave_q_error()}")
        self.disconnect_from_db()

