PATH = '/u/y/u/yunjia/nobackup/yunjia/adaptiveness_vs_learning/runtime_eval'
import sys
sys.path.append(PATH)
from core.QueryEvaluator import *

# Example usage:
db_config = {
    'dbname': 'imdbload',
    'user': 'yunjia',
    'password': 'yunjia',
    'host': 'localhost',
    'port': '5433'
}

query_directory = './ceb-imdb-rand/lip_aja_auto_rewrite/'
# workload_names = ['ceb-imdb-rand']
workload_names = ['ceb-imdb-slow']

# read workload name from command line
# workload_names = [sys.argv[1]]
for w in workload_names:
    query_directory = './' + w + '/lip_aja_auto_rewrite/'
    evaluator = PostgresLIPQueryEvaluator(db_config, query_directory, debug_mode=False)
    evaluator.run(
        query_log_file = f'postgres-{w}.json',
    )
