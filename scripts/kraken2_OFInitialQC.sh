#!/bin/bash

#SBATCH -A C3SE408-25-2 
#SBATCH -J kraken2_ZS1B1_1_initial
#SBATCH -p vera
#SBATCH -N 1 --cpus-per-task=12
#SBATCH -t 05:00:00
#SBATCH --output=/cephyr/users/alvinsu/Vera/BIO511/ZS1B1_1_WGS_project/logs/kraken2_classification/%j_Initial_kraken2.out # output log, adjust path to where you want to save logs
#SBATCH --error=/cephyr/users/alvinsu/Vera/BIO511/ZS1B1_1_WGS_project/logs/kraken2_classification/%j_Initial_kraken2.err # error log, adjust path to where you want to save logs
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=gusalvisu@student.gu.se

# Setting Paths
CONTAINER_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/BIO511/singularity_images/kraken2.sif"
DB_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/BIO511/ref_dbs/kraken2db"
DATA_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/students/Alvin/BIO511/ZS1B1_1_WGS_project/data/fastplong_QC"
RESULTS_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/students/Alvin/BIO511/ZS1B1_1_WGS_project/results/kraken2_results"
LOG_PATH="/cephyr/users/alvinsu/Vera/BIO511/ZS1B1_1_WGS_project/logs/kraken2_classification"

# Bind paths for container
export SINGULARITY_BINDPATH="${DB_PATH}:/database,${DATA_PATH}:/seqdata,${RESULTS_PATH}:/results"

echo "Processing 12_10_2025_ZS1B1_1_initial_QC.fastq.gz"
# Extracting JOBID from temporary log files and fetching current date.
#BASE_JOBID=$(basename $(ls ${LOG_PATH}/kraken2.out$) "_Initial_kraken2.out")
CurrentDate=$(date -d today +"%d_%m_%Y")

# Run Kraken2 classification
srun singularity exec ${CONTAINER_PATH} kraken2 \
    --db /database \
    --threads 12 \
    --gzip-compressed \
    --output /results/${CurrentDate}_ZS1B1_1_kraken2_Initial_output.txt \
    --report /results/${CurrentDate}_ZS1B1_1_kraken2_Initial_report.txt \
    --classified-out /results/${CurrentDate}_ZS1B1_1_kraken2_Initial_classified#.fastq \
    --unclassified-out /results/${CurrentDate}_ZS1B1_1_kraken2_Initial_unclassified#.fastq \
    /seqdata/12_10_2025_ZS1B1_1_initial_QC.fastq.gz

    echo "Completed classification of ZS1B1_1"


# Renaming log-files to include current date
#mv ${LOG_PATH}/kraken2.out$ ${LOG_PATH}/${CurrentDate}_ZS1B1_1_kraken2_${BASE_JOBID}_OfInitial.out
#mv ${LOG_PATH}/kraken2.err$ ${LOG_PATH}/${CurrentDate}_ZS1B1_1_kraken2_${BASE_JOBID}_OfInitial.err

#if [ -f "${LOG_PATH}/${CurrentDate}_ZS1B1_1_kraken2_${BASE_JOBID}_OfInitial.err" ] && [ -f "${LOG_PATH}/${CurrentDate}_ZS1B1_1_kraken2_${BASE_JOBID}_OfInitial.out" ]; then
#    echo "All log files have been renamed to contain current date. Job naming test completed"
#
#else
#    echo "Failed to rename all files. Check ${LOG_PATH} for potential source of error."
#    rm ${LOG_PATH}/${BASE_JOBID}_kraken2.out
#fi