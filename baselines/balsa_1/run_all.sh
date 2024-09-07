python3 run.py --run Balsa_CEBIMDBRandSplit_Sample --wandb_name Balsa_CEBIMDBRandSplit_Sample_baseline --local

python3 run.py --run Balsa_CEBIMDBRandSplit_Sample --wandb_name Balsa_CEBIMDBRandSplit_Sample_try1 --local &
python3 run.py --run Balsa_CEBIMDBRandSplit_Sample --wandb_name Balsa_CEBIMDBRandSplit_Sample_try2 --local &
python3 run.py --run Balsa_CEBIMDBRandSplit_Sample --wandb_name Balsa_CEBIMDBRandSplit_Sample_try3 --local &

wait 

