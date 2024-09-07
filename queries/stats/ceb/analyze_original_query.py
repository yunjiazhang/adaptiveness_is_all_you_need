#!/usr/bin/env python
# coding: utf-8

# In[10]:


# get_ipython().run_line_magic('load_ext', 'autoreload')
# get_ipython().run_line_magic('autoreload', '2')


# In[11]:


PATH = '/nobackup/yunjia/adaptiveness_vs_learning/runtime_eval/'
import sys
sys.path.append(PATH)
# from core.eval_Runtime import *
from core.QueryEvaluator import *
import os


# In[20]:


all_needed_query_files = []
stats_rand_queries_dir = './stats_rand/'
for q in os.listdir(stats_rand_queries_dir):
    if q.endswith('.sql'):
        all_needed_query_files.append(q)

stats_slow_queries_dir = './stats_slow/'
for q in os.listdir(stats_slow_queries_dir):
    if q.endswith('.sql'):
        all_needed_query_files.append(q)


# In[21]:


import sqlparse
def sql_formater(sql):
    return sqlparse.format(sql, reindent=True, keyword_case='upper')


# # Evaluate CEB

# In[23]:


db_config = {
    'dbname': 'stats',
    'user': 'yunjia',
    'password': 'yunjia',
    'host': 'localhost',
    'port': '5433'
}

query_directory = './all/'
print("Running queries: ", all_needed_query_files)



# for ceb_file_name in [
#     'stats_CEB_sub_queries_bayescard.txt',
#     'stats_CEB_sub_queries_deepdb.txt',
#     'stats_CEB_sub_queries_flat.txt',
#     'stats_CEB_sub_queries_neurocard.txt'
# ]:

def eval_CEB(ceb_file_name):
    evaluator = PostgresCEBQueryEvaluator(
        db_config, 
        query_directory,
        query_files=all_needed_query_files,                                   
        debug_mode=False, 
        ceb_file_name=ceb_file_name
    )

    evaluator.run(
        query_log_file = f'ceb-stats-{ceb_file_name.split(".")[0]}.json',
        rerun_finished=False,
        sample_size=None
    )

# parallel run of all ceb files
from joblib import Parallel, delayed
Parallel(n_jobs=2)(delayed(eval_CEB)(ceb_file_name) for ceb_file_name in [
    'stats_CEB_sub_queries_bayescard.txt',
    'stats_CEB_sub_queries_deepdb.txt',
    'stats_CEB_sub_queries_flat.txt',
    'stats_CEB_sub_queries_neurocard.txt'
])


# In[19]:


# total_time = 0
# for q in slow_queries:
#     total_time += sorted_dict[q]
# print("Stats slow total time: ", total_time)

# total_time = 0
# for q in random_queries:
#     total_time += sorted_dict[q]
# print("Stats rand total time: ", total_time)


# In[ ]:




