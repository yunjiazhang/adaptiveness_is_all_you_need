#!/usr/bin/env python
# coding: utf-8

# In[4]:


# %load_ext autoreload
# %autoreload 2

PATH = '/mnt/adaptiveness_vs_learning/runtime_eval/'
import sys
sys.path.append(PATH)
from core.eval_Runtime import *


# In[5]:


query_dirs = {
    'pg_stats_all': '/mnt/adaptiveness_vs_learning/queries/stats/original/all/',
    'pg_stats_lip+aja_slow': '/mnt/adaptiveness_vs_learning/queries/stats/LIP+AJA/stats_slow/',
}

stats_all_queries = [f'{i+1}.sql' for i in range(146)]
stats_slow_queries = ['105.sql',
 '107.sql',
 '108.sql',
 '115.sql',
 '120.sql',
 '122.sql',
 '123.sql',
 '126.sql',
 '134.sql',
 '135.sql',
 '136.sql',
 '138.sql',
 '140.sql',
 '141.sql',
 '142.sql',
 '143.sql',
 '30.sql',
 '34.sql',
 '38.sql',
 '49.sql',
 '51.sql',
 '52.sql',
 '56.sql',
 '58.sql',
 '59.sql',
 '68.sql',
 '69.sql',
 '70.sql',
 '71.sql']


# In[ ]:





# In[ ]:


engine_name = 'postgres_pg_lip'
db_name = 'stats'
query_dir = '/mnt/adaptiveness_vs_learning/queries/stats/LIP+AJA/stats_slow/'
init_sql_file= '/mnt/adaptiveness_vs_learning/queries/lip_bloom_init.sql'
run_queries = stats_slow_queries

pg_db = DB_instance(engine_name, db_name)
pg_ev = PG_LIP_Runtime_Evaluator(pg_db, query_dir, init_sql_file=init_sql_file)
pg_ev.evaluate_queries(
    sql_dir=query_dir,
    save_json_file=f'./{engine_name}_LIP+AJA_{db_name}_runtimes.json', 
    sql_files=run_queries,
    rerun_finished=False,
    multiple_runs=2, 
    save_plan=False,
    disable_op="mergejoin",
)


# In[ ]:


import json
import numpy as np
logs = json.load(open(f'./{engine_name}_LIP+AJA_{db_name}_runtimes.json'))
total_runtimes = 0
for q in logs:
    time = np.average([t[1] + t[2] for t in logs[q]])
    total_runtimes += time
print(f"Total workload time ({len(logs)} queries): ", total_runtimes)


# In[ ]:




