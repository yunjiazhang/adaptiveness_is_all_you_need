# Queries used for evaluation


- ./job/ contains the original queries, and the corresponding plans picked by PG/12 are shown in ./job/plan/
- ./job_balsa/ contains the plans picked by Balsa (using pg_hint_plan). The plans are shown in ./job_balsa/plan/
- ./job_pg_lip/ contains the rewritten queries using the extension pg_lip_bloom. The plans are in ./job_pg_lip/plan/

To visualize the plans, copy the text in XXX_plan.txt to [pg_plan_visualize](https://explain.dalibo.com/). 



