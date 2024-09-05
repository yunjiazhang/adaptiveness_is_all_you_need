#!/usr/bin/env python
# coding: utf-8

# In[1]:


# get_ipython().run_line_magic('load_ext', 'autoreload')
# get_ipython().run_line_magic('autoreload', '2')
PATH = '/mnt/adaptiveness_vs_learning/runtime_eval/'
import sys
sys.path.append(PATH)
from core.eval_Runtime import *
from core.QueryEvaluator import *


# In[2]:


all_stats_queries_dir = './all/'
all_stats_qureies = [q for q in os.listdir(all_stats_queries_dir) if q.endswith('.sql')]


# In[3]:


import sqlparse
def sql_formater(sql):
    return sqlparse.format(sql, reindent=True, keyword_case='upper')


# # Evaluate CEB

# In[ ]:


db_config = {
    'dbname': 'stats',
    'user': 'postgres',
    'password': 'postgres',
    'host': 'localhost',
    'port': '5432'
}

query_directory = './all/'
print("Running queries: ", os.listdir(query_directory))

# import sys
# ceb_file_name = sys.argv[1]

for ceb_file_name in [
    'stats_CEB_sub_queries_bayescard.txt',
    'stats_CEB_sub_queries_deepdb.txt',
    'stats_CEB_sub_queries_flat.txt',
    'stats_CEB_sub_queries_neurocard.txt'
]:
# assert ceb_file_name in [ 
#     'stats_CEB_sub_queries_bayescard.txt',
#     'stats_CEB_sub_queries_deepdb.txt',
#     'stats_CEB_sub_queries_flat.txt',
#     'stats_CEB_sub_queries_neurocard.txt'
# ], "You should provide a valide ceb_file_name"

    evaluator = PostgresCEBQueryEvaluator(
        db_config, 
        query_directory,                                   
        debug_mode=False, 
        ceb_file_name=ceb_file_name
    )
    
    evaluator.run(
        query_log_file = f'ceb-stats-{ceb_file_name.split(".")[0]}.json',
        rerun_finished=False,
        sample_size=None
    )


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




