#!/bin/bash
#SBATCH -C centos7
#SBATCH --mem-per-cpu=10000
#SBATCH --mail-type=END #Mail when job ends
#SBATCH --mail-user=razgaon@mit.edu #email recipient

module load R/4.1.0
module load anaconda3/2021.11

# pip install pandas --user

Rscript nsclc_step_1.R
Rscript pbmc_step_1.R
# Rscript impute_data.R

