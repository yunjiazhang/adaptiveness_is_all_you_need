#!/usr/bin/env python
# coding: utf-8

# In[10]:


# get_ipython().run_line_magic('load_ext', 'autoreload')
# get_ipython().run_line_magic('autoreload', '2')
PATH = '/nobackup/yunjia/adaptiveness_vs_learning/runtime_eval/'
import sys
sys.path.append(PATH)
# from core.eval_Runtime import *
from core.QueryEvaluator import *


# In[2]:


all_stats_queries_dir = './all/'
all_stats_qureies = [q for q in os.listdir(all_stats_queries_dir) if q.endswith('.sql')]


# In[3]:


import sqlparse
def sql_formater(sql):
    return sqlparse.format(sql, reindent=True, keyword_case='upper')


# # Evaluate the original PG

# In[ ]:


db_config = {
    'dbname': 'stats',
    'user': 'yunjia',
    'password': 'yunjia',
    'host': 'localhost',
    'port': '5433'
}

query_directory = './all/'
print("Running queries: ", os.listdir(query_directory))


evaluator = PostgresQueryEvaluator(
    db_config, 
    query_directory,                                   
    debug_mode=False, 
)

evaluator.run(
    query_log_file = f'postgres-stats-original-config.json',
    rerun_finished=False,
    sample_size=None
)


# In[ ]:





# In[ ]:





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




