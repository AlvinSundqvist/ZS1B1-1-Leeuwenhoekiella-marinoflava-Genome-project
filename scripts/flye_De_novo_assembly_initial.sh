#!/bin/bash

#SBATCH -A C3SE408-25-2
#SBATCH -J flye_ZS1B1_1_De_novo_assembly_5xpolished
#SBATCH -p vera
#SBATCH -N 1 --cpus-per-task=16
#SBATCH -t 01:03:00
#SBATCH --output=/cephyr/users/alvinsu/Vera/BIO511/ZS1B1_1_WGS_project/logs/flye_assembly/flye_basic_%j.out
#SBATCH --error=/cephyr/users/alvinsu/Vera/BIO511/ZS1B1_1_WGS_project/logs/flye_assembly/flye_basic_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=gusalvisu@student.gu.se

# Set paths - ADJUST THESE TO YOUR ACTUAL PATHS
DATA_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/students/Alvin/BIO511/ZS1B1_1_WGS_project/data/fastplong_QC"
RESULTS_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/students/Alvin/BIO511/ZS1B1_1_WGS_project/results/flye_results"
SINGULARITY_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/BIO511/singularity_images/flye.sif"

# Set bind paths for Singularity
export SINGULARITY_BINDPATH="${DATA_PATH}:/data,${RESULTS_PATH}:/results"

# Fetching current date
CurrentDate=$(date -d today +"%d_%m_%Y")

# Run Flye assembly with basic settings
echo "Now running De-novo genome assembly of ZS1B1-1 using flye"
singularity exec ${SINGULARITY_PATH} flye --nano-raw /data/20_10_2025_ZS1B1-1_initial_QC_filtered.fastq.gz \
    --out-dir /results/${CurrentDate}_flye_De_novo_assembly \
    --threads 16 \
    --iterations 5

echo "De-novo assembly of Z1S1B1-1 ONT-reads has been completed"