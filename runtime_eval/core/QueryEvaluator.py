# # %load_ext autoreload
# # %autoreload 2
# PATH = '/u/y/u/yunjia/nobackup/yunjia/adaptiveness_vs_learning/runtime_eval'
# import sys
# sys.path.append(PATH)
# from core.eval_Runtime import *

import os
import time
import json
import psycopg2
from psycopg2 import sql
from tqdm import tqdm

class PostgresQueryEvaluator:
    def __init__(self, db_config, query_directory,
                 debug_mode=False, timeout_mil=1200000
                ):
        """
        Initializes the QueryEvaluator with database configuration and the directory containing the queries.
        
        :param db_config: Dictionary with database connection parameters (dbname, user, password, host, port)
        :param query_directory: Directory where the query files are stored.
        """
        self.db_config = db_config
        self.query_directory = query_directory
        self.query_log_file = None
        self.debug_mode = debug_mode
        self.MAX_RUNS = 1
        self.SAVE_FREQ = 1
        self.timeout_mil = timeout_mil

    def connect_to_db(self):
        """Establishes a connection to the PostgreSQL database."""
        try:
            self.conn = psycopg2.connect(**self.db_config)
            self.cursor = self.conn.cursor()
            if self.timeout_mil is not None:
                self.execute_query(f"set statement_timeout to {self.timeout_mil};")
                timeout = self.execute_query(f"show statement_timeout;")
                print(f"Set statment timetout to {timeout}")
            print("Connected to the database successfully.")
        except Exception as e:
            print(f"Error connecting to the database: {e}")

    def disconnect_from_db(self):
        """Closes the database connection."""
        if self.cursor:
            self.cursor.close()
        if self.conn:
            self.conn.close()
            print("Database connection closed.")
    
    def execute_query(self, query, return_results=True):
        """Executes the given query and returns the results."""
        try:
            self.cursor.execute(query)
            self.conn.commit()
            if return_results:
                return self.cursor.fetchall()
        except Exception as e:
            print(f"Error executing query: {e}")
            self.conn.rollback()

    def explain_query(self, query, execute=True):
        try:
            # explain and return json
            if execute:
                sql_string = sql.SQL("EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON) {}").format(sql.SQL(query))
            else:
                sql_string = sql.SQL("EXPLAIN (COSTS, VERBOSE, FORMAT JSON) {}").format(sql.SQL(query))
            self.cursor.execute(sql_string)
            return self.cursor.fetchall()
        except Exception as e:
            print(f"Error explaining query: {e}")
            self.conn.rollback()

    def evaluate_queries(
                self,
                rerun_finished=False,
                sample_size=None,
            ):
        
        """Evaluates the execution time of queries in the directory and outputs the result as a JSON dictionary."""
        if self.query_log_file and os.path.exists(self.query_log_file):
            with open(self.query_log_file, 'r') as infile:
                query_times = json.load(infile)
        else:
            query_times = {}
        
        all_queries = sorted([q for q in os.listdir(self.query_directory)])
        if sample_size is not None:
            import random
            all_queries = random.sample(all_queries, sample_size)
        for qn, query_file in enumerate(all_queries):
            print(f"Running query {query_file} ({qn} / {len(all_queries)})...")
            query_path = os.path.join(self.query_directory, query_file)
            if not (query_file not in query_times or rerun_finished):
                print(f"\tQuery {query_file} has already been evaluated. Skipping...")
                continue
            if os.path.isfile(query_path) and query_file.endswith('.sql'):
                with open(query_path, 'r') as file:
                    query = file.read()
                if self.debug_mode:
                    print(query)
                
                execution_times = []
                for i in range(self.MAX_RUNS):
                    start_time = time.time()
                    try:
                        self.cursor.execute(query)
                        self.conn.commit() 
                    except Exception as e:
                        print(f"\tError executing query {query_file}: {e}")
                        self.conn.rollback()
                        execution_times.append(self.timeout_mil)
                        break
                    end_time = time.time()
                    execution_times.append(end_time - start_time)
                    print(f"\tQuery {query_file} executed successfully in {end_time - start_time:.2f} seconds.")
                
                query_times[query_file] = execution_times
        
            # Output the results to a JSON dictionary
            if qn % self.SAVE_FREQ == 0 or qn == len(all_queries) - 1:
                with open(self.query_log_file, 'w') as outfile:
                    json.dump(query_times, outfile, indent=4)
        
        print(f"Query execution times have been saved to {self.query_log_file}.")

    def run(
            self, 
            query_log_file='query_execution_times.json',
            rerun_finished=False,
            sample_size=None
            ):
        """Runs the entire evaluation process."""
        self.query_log_file = query_log_file
        self.connect_to_db()
        self.evaluate_queries(
            rerun_finished=rerun_finished,
            sample_size=sample_size)
        self.disconnect_from_db()


class PostgresCEBQueryEvaluator(PostgresQueryEvaluator):
    def __init__(self, 
                 db_config, 
                 query_directory, 
                 debug_mode=False,
                 ceb_file_name='stats_CEB_sub_queries_bayescard.txt'
                 ):
        super().__init__(db_config, query_directory)
        self.debug_mode = debug_mode
        self.ceb_file_name = ceb_file_name

    def post_connection_config(self) :
        self.cursor.execute("SET ml_cardest_enabled=true;")
        self.cursor.execute("SET ml_joinest_enabled=true;")
        self.cursor.execute("SET query_no=0;")
        self.cursor.execute("SET join_est_no=0;")
        self.cursor.execute(f"SET ml_cardest_fname='{self.ceb_file_name}';")
        self.cursor.execute(f"SET ml_joinest_fname='{self.ceb_file_name}';")

        results = self.execute_query('SHOW ml_cardest_fname;')
        print("Using ml_cardest_fname = ", results)
        results = self.execute_query('SHOW ml_joinest_fname;')
        print("Using ml_joinest_fname = ", results)
    
    def connect_to_db(self):
        """Establishes a connection to the PostgreSQL database."""
        super().connect_to_db()
        self.post_connection_config()
    
    def run(
            self, 
            query_log_file='ceb_query_execution_times.json',
            rerun_finished=False,
            sample_size=None
            ):
        """Runs the entire evaluation process."""
        self.query_log_file = query_log_file
        self.connect_to_db()
        self.evaluate_queries(
            rerun_finished=rerun_finished, 
            sample_size=sample_size
        )
        self.disconnect_from_db()
        

class PostgresLIPQueryEvaluator(PostgresQueryEvaluator):
    def __init__(self, db_config, query_directory, debug_mode=False):
        super().__init__(db_config, query_directory)
        self.debug_mode = debug_mode

    def connect_to_db(self):
        """Establishes a connection to the PostgreSQL database."""
        super().connect_to_db()
        self.cursor.execute("DROP EXTENSION IF EXISTS pg_lip_bloom;")
        self.cursor.execute("CREATE EXTENSION pg_lip_bloom;")

    def evaluate_queries(
                self,
                rerun_finished=False,
                sample_size=None
            ):
        
        """Evaluates the execution time of queries in the directory and outputs the result as a JSON dictionary."""
        if self.query_log_file and os.path.exists(self.query_log_file):
            with open(self.query_log_file, 'r') as infile:
                query_times = json.load(infile)
        else:
            query_times = {}
        
        all_queries = sorted([q for q in os.listdir(self.query_directory)])
        if sample_size is not None:
            import random
            all_queries = random.sample(all_queries, sample_size)
        for qn, query_file in enumerate(all_queries):
            print(f"Running query {query_file} ({qn} / {len(all_queries)})...")
            query_path = os.path.join(self.query_directory, query_file)
            if not (query_file not in query_times or rerun_finished):
                print(f"\tQuery {query_file} has already been evaluated. Skipping...")
                continue
            if os.path.isfile(query_path) and query_file.endswith('.sql'):
                with open(query_path, 'r') as file:
                    query = file.read()
                
                queries_splited = query.split(';')
                # remove the last empty string
                queries_splited = queries_splited[:-1]
                # remove commented lines
                queries_splited = [q for q in queries_splited if not q.startswith('--')]
                prepration_queries = [q for q in queries_splited if (
                    'pg_lip_bloom_set_dynamic' in q
                    or 'pg_lip_bloom_init' in q)]
                execution_queries = [q for q in queries_splited if (
                    'pg_lip_bloom_set_dynamic' not in q
                    and 'pg_lip_bloom_init' not in q)] 

                execution_times = []
                for i in range(self.MAX_RUNS):
                    for q in prepration_queries:
                        try:
                            self.cursor.execute(q)
                            self.conn.commit() 
                        except Exception as e:
                            print(f"\tError executing query {query_file}: {e}")
                            self.conn.rollback()
                            execution_times.append(self.timeout_mil)
                            break
                        if self.debug_mode:
                            print(f"\tQuery {q}: executed successfully.")
                    current_execution_times = []
                    for q in execution_queries:
                        start_time = time.time()
                        try:
                            self.cursor.execute(q)
                            self.conn.commit() 
                        except Exception as e:
                            print(f"\tError executing query {q}: {e}")
                            self.conn.rollback()
                            continue
                        end_time = time.time()
                        if self.debug_mode:
                            print(f"\tQuery {q}: executed successfully with time {end_time - start_time:.2f} seconds.")
                        current_execution_times.append(end_time - start_time)
                    execution_times.append(current_execution_times)
                    print(f"\tQuery {query_file} executed successfully in {current_execution_times} seconds.")
                
                query_times[query_file] = execution_times
        
            # Output the results to a JSON dictionary
            if qn % 10 == self.SAVE_FREQ or qn == len(all_queries) - 1:
                with open(self.query_log_file, 'w') as outfile:
                    json.dump(query_times, outfile, indent=4)
        
        print(f"Query execution times have been saved to {self.query_log_file}.")
