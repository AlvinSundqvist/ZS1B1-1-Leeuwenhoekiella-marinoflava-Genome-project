#!/bin/bash
#SBATCH -A C3SE408-25-2
#SBATCH -J quast_analysis_ZS1B1-1-5x-polished
#SBATCH -p vera
#SBATCH -N 1 --cpus-per-task=4
#SBATCH -t 00:10:00
#SBATCH --output=/cephyr/users/alvinsu/Vera/BIO511/ZS1B1_1_WGS_project/logs/quast_statistics/%j_quast_initial.out
#SBATCH --error=/cephyr/users/alvinsu/Vera/BIO511/ZS1B1_1_WGS_project/logs/quast_statistics/%j_quast_initial.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=gusalvisu@student.gu.se

# Load or use containerized QUAST
CONTAINER_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/BIO511/singularity_images/quast.sif"
DATA_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/students/Alvin/BIO511/ZS1B1_1_WGS_project/results/flye_results/21_10_2025_flye_De_novo_assembly"
RESULTS_PATH="/cephyr/NOBACKUP/groups/n2bin_gu/students/Alvin/BIO511/ZS1B1_1_WGS_project/results/quast_statistics"

# Bind paths for container
export SINGULARITY_BINDPATH="${DATA_PATH}:/data,${RESULTS_PATH}:/results"

# Run QUAST on both assemblies
singularity exec ${CONTAINER_PATH} quast.py \
    -o /results/5xPolish/ \
    --threads 4 \
    --plots-format png \
    --labels "Polished" \
    /data/assembly.fasta

echo "QUAST analysis completed"