# # %load_ext autoreload
# # %autoreload 2
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
    'port': '5432'
}

query_directory = './all/'

evaluator = PostgresQueryEvaluator(db_config, query_directory)
evaluator.run(
    query_log_file='postgres_imdbload_runtimes.json',
    rerun_finished=False
)
