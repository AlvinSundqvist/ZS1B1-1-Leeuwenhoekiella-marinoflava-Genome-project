#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J prokka_ZS1B1-1_baseline
#SBATCH -p vera
#SBATCH -N 1 --cpus-per-task=8
#SBATCH -t 01:00:00
#SBATCH --output=/cephyr/users/alvinsu/Vera/BIO511/ZS1B1_1_WGS_project/logs/prokka_annotation/%j_prokka_CuratedRef.out # output log 
#SBATCH --error=/cephyr/users/alvinsu/Vera/BIO511/ZS1B1_1_WGS_project/logs/prokka_annotation/%j_prokka_CuratedRef.err # error log
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=gusalvisu@student.gu.se

# Set paths
CONTAINER_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/BIO511/singularity_images/prokka.sif"
RESULTS_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/students/Alvin/BIO511/ZS1B1_1_WGS_project/results/prokka_annotation"
ASSEMBLIES_DIR="/cephyr/NOBACKUP/groups/n2bin_gu/students/Alvin/BIO511/ZS1B1_1_WGS_project/results/flye_results/21_10_2025_flye_De_novo_assembly"
CURATED_PROTEINS="/cephyr/NOBACKUP/groups/n2bin_gu/students/Alvin/BIO511/ZS1B1_1_WGS_project/data/"
OUTPUT_DIR="${RESULTS_PATH}/prokka_annotation/prokka_curated"

# Bind paths for container
export SINGULARITY_BINDPATH="${ASSEMBLIES_DIR}:/assemblies,${RESULTS_PATH}:/results,${CURATED_PROTEINS}:/reference"

CurrentDate=$(date -d today +"%d_%m_%Y")

echo "Processing sample: ${sample}"

# Run Prokka (curated)
singularity exec ${CONTAINER_PATH} prokka \
  --cpus 8 \
  --force \
  --outdir /results/${CurrentDate}_ZS1B1-1_prokka_Curated/ \
  --prefix ZS1B1-1 \
  --locustag Leeuwenhoekiella_marinoflava \
  --genus  Leeuwenhoekiella \
  --species marinoflava \
  --proteins /reference/ZS1B1-1_CuratedRef.faa \
  /assemblies/assembly.fasta

echo "Curated Prokka annotation completed"

# Extracting JOBID from temporary log files and fetching current date.
#BASE_JOB_NAME=$(basename $(ls /cephyr/users/alvinsu/Vera/BIO511/Genomics_practical_3/tmp/*.out) ".out")

#TMP_DIR=/cephyr/users/alvinsu/Vera/BIO511/Genomics_practical_3/tmp
#LOG_DIR=/cephyr/users/alvinsu/Vera/BIO511/Genomics_practical_3/logs

# Renaming log-files to include current date
#mv ${TMP_DIR}/${BASE_JOB_NAME}.out ${LOG_DIR}/${CurrentDate}_${BASE_JOB_NAME}.out
#mv ${TMP_DIR}/${BASE_JOB_NAME}.err ${LOG_DIR}/${CurrentDate}_${BASE_JOB_NAME}.err

#if [ -f "${LOG_DIR}/${CurrentDate}_${BASE_JOB_NAME}.err" ] && [ -f "${LOG_DIR}/${CurrentDate}_${BASE_JOB_NAME}.out" ]; then
#    echo "All log files have been renamed to contain current date. Job naming test completed"
#
#else
#    echo "Failed to rename all files. Check /cephyr/users/alvinsu/Vera/BIO511/Genomics_practical_3/tmp/ for source of error."
#fi