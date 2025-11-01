#!/bin/bash

#SBATCH -A C3SE408-25-2 
#SBATCH -J kraken2_ZS1B1_1_filtered
#SBATCH -p vera
#SBATCH -N 1 --cpus-per-task=12
#SBATCH -t 00:10:00
#SBATCH --output=/cephyr/users/alvinsu/Vera/BIO511/ZS1B1_1_WGS_project/logs/kraken2_classification/%j_kraken2_Filtered.out # output log, adjust path to where you want to save logs
#SBATCH --error=/cephyr/users/alvinsu/Vera/BIO511/ZS1B1_1_WGS_project/logs/kraken2_classification/%j_kraken2_Filtered.err # error log, adjust path to where you want to save logs
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

echo "Processing 20_10_2025_ZS1B1-1_initial_QC_filtered.fastq.gz"
# Extracting JOBID from temporary log files and fetching current date.
BASE_JOBID=$((basename $(ls ${LOG_PATH}/*output_kraken2_Filtered_)) | sed 's/output_kraken2_Filtered_//')
echo $BASE_JOBID
CurrentDate=$(date -d today +"%d_%m_%Y")

# Run Kraken2 classification
srun singularity exec ${CONTAINER_PATH} kraken2 \
    --db /database \
    --threads 12 \
    --output /results/${CurrentDate}_ZS1B1_1_kraken2_Filtered_output.txt \
    --report /results/${CurrentDate}_ZS1B1_1_kraken2_Filtered_report.txt \
    --classified-out /results/${CurrentDate}_ZS1B1_1_kraken2_Filtered_classified#.fastq \
    --unclassified-out /results/${CurrentDate}_ZS1B1_1_kraken2_Filtered_unclassified#.fastq \
    /seqdata/20_10_2025_ZS1B1-1_initial_QC_filtered.fastq.gz

    echo "Completed classification of ZS1B1_1"


# Renaming log-files to include current date
#mv ${LOG_PATH}/*output_kraken2_Filtered ${LOG_PATH}/${CurrentDate}_${BASE_JOBID}_ZS1B1_1_kraken2_Filtered.out
#mv ${LOG_PATH}/*error_kraken2_Filtered ${LOG_PATH}/${CurrentDate}_${BASE_JOBID}_ZS1B1_1_kraken2_Filtered.err

#if [ -f "${LOG_PATH}/${CurrentDate}_${BASE_JOBID}_ZS1B1_1_kraken2_Filtered.err" ] && [ -f "${LOG_PATH}/${CurrentDate}_${BASE_JOBID}_ZS1B1_1_kraken2_Filtered.out" ]; then
#    echo "All log files have been renamed to contain current date. Job naming test completed"

#else
#    echo "Failed to rename all files. Check ${LOG_PATH} for potential source of error."
#    rm ${LOG_PATH}/${BASE_JOBID}_kraken2_Filtered.out
#fi