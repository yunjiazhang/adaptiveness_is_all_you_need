#!/usr/bin/env python
# coding: utf-8

# In[16]:


# %load_ext autoreload
# %autoreload 2

PATH = '/mnt/adaptiveness_vs_learning/runtime_eval/'
import sys
sys.path.append(PATH)
from core.eval_Runtime import *


# In[17]:


query_dirs = {
    'pg_stats_all': '/mnt/adaptiveness_vs_learning/queries/stats/original/all/',
}

stats_all_queries = [f'{i+1}.sql' for i in range(146)]

job_slow_queries = [
    '16b.sql', '17a.sql', '17e.sql', '17f.sql', '17b.sql', '19d.sql', '17d.sql',
    '17c.sql', '10c.sql', '26c.sql', '25c.sql', '6d.sql', '6f.sql', '8c.sql',
    '18c.sql', '9d.sql', '30a.sql', '19c.sql', '20a.sql'
]

job_rand_queries = [
    '8a.sql', '16a.sql', '2a.sql', '30c.sql', '17e.sql', '20a.sql', '26b.sql',
    '12b.sql', '15b.sql', '15d.sql', '10b.sql', '15a.sql', '4c.sql', '4b.sql',
    '22b.sql', '17c.sql', '24b.sql', '10a.sql', '22c.sql'
]

all_JOB_queries = [
    '30a.sql', '1d.sql', '25a.sql', '6b.sql', '19c.sql', '28b.sql', 
    '9b.sql', '33b.sql', '32a.sql', '27a.sql', '20b.sql', '17d.sql', 
    '16b.sql', '10b.sql', '6a.sql', '17b.sql', '25b.sql', '8b.sql', 
    '31b.sql', '33c.sql', '23a.sql', '15a.sql', '21b.sql', '11d.sql', 
    '9a.sql', '6d.sql', '24a.sql', '17e.sql', '19a.sql', '1c.sql', 
    '25c.sql', '31a.sql', '23c.sql', '17f.sql', '19b.sql', '9d.sql', 
    '27b.sql', '11b.sql', '7b.sql', '19d.sql', '1a.sql', '11c.sql', 
    '31c.sql', '28a.sql', '3c.sql', '6c.sql', '26b.sql', '16a.sql', 
    '7a.sql', '29b.sql', '29a.sql', '1b.sql', '6e.sql', '13d.sql', 
    '10c.sql', '26a.sql', '4b.sql', '10a.sql', '15b.sql', '15d.sql', 
    '26c.sql', '14b.sql', '15c.sql', '14c.sql', '13b.sql', '3a.sql', 
    '24b.sql', '5a.sql', '8c.sql', '6f.sql', '8a.sql', '27c.sql', 
    '12a.sql', '22a.sql', '17a.sql', '13a.sql', '21a.sql', '12b.sql', 
    '13c.sql', '8d.sql', '21c.sql', '7c.sql', '2a.sql', '3b.sql', 
    '16c.sql', '9c.sql', '32b.sql', '28c.sql', '33a.sql', '11a.sql', 
    '18a.sql', '5c.sql', '22d.sql', '18c.sql', '5b.sql', '2c.sql', 
    '16d.sql', '4a.sql', '22c.sql', '12c.sql', '29c.sql', '30b.sql', 
    '2d.sql', '14a.sql', '17c.sql', '22b.sql', '30c.sql', '20a.sql', 
    '20c.sql', '2b.sql', '4c.sql', '18b.sql', '23b.sql'
]


# In[19]:


import sqlparse

def sql_formater(sql):
    return sqlparse.format(sql, reindent=True, keyword_case='upper')


# In[20]:


engine_name = 'postgres'
db_name = 'stats'
query_dir = query_dirs['pg_stats_all']
run_queries = stats_all_queries

pg_db = DB_instance(engine_name, db_name)
pg_ev = Runtime_Evaluator(pg_db, query_dir)
pg_ev.evaluate_queries(
    sql_dir=query_dir,
    sql_files=run_queries,
    save_json_file=f'./{engine_name}_{db_name}_runtimes.json', 
    rerun_finished=True,
    disable_op="mergejoin",
    disable_parallel=False,
    multiple_runs=2,
    save_plan=False,
    timeout=6000
)


# In[21]:


import json
runtimes = json.load(open("./postgres_stats_runtimes.json", 'r'))


# In[22]:


import numpy as np
runtimes = {q_name: np.average(runtimes[q_name]) for q_name in runtimes}


# In[23]:


sorted_dict = dict(sorted(runtimes.items(), key=lambda item: -item[1]))
sorted_dict


# In[24]:


query_num = len(sorted_dict)
query_set_num = int(0.2*query_num)
slow_queries = list(sorted_dict.keys())[:query_set_num]

import random
random_queries = random.sample(list(sorted_dict.keys()), query_set_num)


# In[25]:


import os

for q in random_queries:
    os.system(f'cp ./all/{q} ./stats_rand/')
    with open(f'./stats_rand/{q}', 'r') as f:
        sql = f.read()
    sql = sql_formater(sql)
    with open(f'./stats_rand/{q}', 'w') as g:
        g.write(sql)
    
for q in slow_queries:
    os.system(f'cp ./all/{q} ./stats_slow/')
    with open(f'./stats_slow/{q}', 'r') as f:
        sql = f.read()
    sql = sql_formater(sql)
    with open(f'./stats_slow/{q}', 'w') as g:
        g.write(sql)
    


# In[27]:


total_time = 0
for q in slow_queries:
    total_time += sorted_dict[q]


# In[28]:


total_time


# In[ ]:




