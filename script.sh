#!/bin/bash
#SBATCH -C centos7
#SBATCH -p sched_mit_hill #Run on sched_engaging_default partition
#SBATCH --mem-per-cpu=50000

module load R/4.1.0
module load anaconda3/2021.11

# pip install pandas --user

# Rscript nsclc_step_1.R
# Rscript pbmc_step_1.R
Rscript impute_data.R

