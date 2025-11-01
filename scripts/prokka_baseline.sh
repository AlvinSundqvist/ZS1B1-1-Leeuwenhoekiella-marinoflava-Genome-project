#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J prokka_ZS1B1-1_baseline
#SBATCH -p vera
#SBATCH -N 1 --cpus-per-task=8
#SBATCH -t 01:00:00
#SBATCH --output=/cephyr/users/alvinsu/Vera/BIO511/ZS1B1_1_WGS_project/logs/prokka_annotation/%j_prokka_baseline.out # output log 
#SBATCH --error=/cephyr/users/alvinsu/Vera/BIO511/ZS1B1_1_WGS_project/logs/prokka_annotation/%j_prokka_baseline.err # error log
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=gusalvisu@student.gu.se

# Set paths
CONTAINER_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/BIO511/singularity_images/prokka.sif"
RESULTS_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/students/Alvin/BIO511/ZS1B1_1_WGS_project/results/prokka_annotation"
ASSEMBLIES_DIR="/cephyr/NOBACKUP/groups/n2bin_gu/students/Alvin/BIO511/ZS1B1_1_WGS_project/results/flye_results/21_10_2025_flye_De_novo_assembly"

# Bind paths for container
export SINGULARITY_BINDPATH="${ASSEMBLIES_DIR}:/assemblies,${RESULTS_PATH}:/results"

CurrentDate=$(date -d today +"%d_%m_%Y")

# Run Prokka on ZS1B1-1 de-novo assembly 
singularity exec ${CONTAINER_PATH} prokka \
    --cpus 8 \
    --force \
    --outdir /results/${CurrentDate}_ZS1B1-1_prokka_baseline/ \
    --prefix ZS1B1-1 \
    --locustag Leeuwenhoekiella_marinoflava \
    --genus  Leeuwenhoekiella \
    --species marinoflava \
    /assemblies/assembly.fasta

echo "Prokka annotation completed"
