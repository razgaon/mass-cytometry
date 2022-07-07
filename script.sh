#!/bin/bash
#SBATCH -C centos7
#SBATCH --mem-per-cpu=50000
#SBATCH --timet 0-04:30 #Request runtime of 30 minutes

module load R/4.1.0
module load anaconda3/2021.11

# pip install pandas --user

# Rscript nsclc_step_1.R
# Rscript pbmc_step_1.R
Rscript impute_data.R

