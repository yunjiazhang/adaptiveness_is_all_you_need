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
    def __init__(self, db_config, query_directory):
        """
        Initializes the QueryEvaluator with database configuration and the directory containing the queries.
        
        :param db_config: Dictionary with database connection parameters (dbname, user, password, host, port)
        :param query_directory: Directory where the query files are stored.
        """
        self.db_config = db_config
        self.query_directory = query_directory
        self.query_log_file = None
        self.MAX_RUNS = 3

    def connect_to_db(self):
        """Establishes a connection to the PostgreSQL database."""
        try:
            self.conn = psycopg2.connect(**self.db_config)
            self.cursor = self.conn.cursor()
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

    def evaluate_queries(
                self,
                rerun_finished=True,
            ):
        
        """Evaluates the execution time of queries in the directory and outputs the result as a JSON dictionary."""
        if self.query_log_file and os.path.exists(self.query_log_file):
            with open(self.query_log_file, 'r') as infile:
                query_times = json.load(infile)
        else:
            query_times = {}
        
        all_queries = sorted([q for q in os.listdir(self.query_directory)])
        for qn, query_file in enumerate(all_queries):
            print(f"Running query {query_file} ({qn} / {len(all_queries)})...")
            query_path = os.path.join(self.query_directory, query_file)
            if not (query_file not in query_times or rerun_finished):
                print(f"\tQuery {query_file} has already been evaluated. Skipping...")
                continue
            if os.path.isfile(query_path) and query_file.endswith('.sql'):
                with open(query_path, 'r') as file:
                    query = file.read()
                
                execution_times = []
                for i in range(self.MAX_RUNS):
                    start_time = time.time()
                    try:
                        self.cursor.execute(query)
                        self.conn.commit() 
                    except Exception as e:
                        print(f"\tError executing query {query_file}: {e}")
                        self.conn.rollback()
                        continue
                    end_time = time.time()
                    execution_times.append(end_time - start_time)
                    print(f"\tQuery {query_file} executed successfully in {end_time - start_time:.2f} seconds.")
                
                query_times[query_file] = execution_times
        
            # Output the results to a JSON dictionary
            if qn % 10 == 0:
                with open(self.query_log_file, 'w') as outfile:
                    json.dump(query_times, outfile, indent=4)
        
        print("Query execution times have been saved to 'query_execution_times.json'.")

    def run(
            self, 
            query_log_file='query_execution_times.json',
            rerun_finished=True,
            ):
        """Runs the entire evaluation process."""
        self.query_log_file = query_log_file
        self.connect_to_db()
        self.evaluate_queries(rerun_finished=rerun_finished)
        self.disconnect_from_db()


# Example usage:
db_config = {
    'dbname': 'imdbload',
    'user': 'yunjia',
    'password': 'yunjia',
    'host': 'localhost',
    'port': '5433'
}

query_directory = './all/'

evaluator = PostgresQueryEvaluator(db_config, query_directory)
evaluator.run()
