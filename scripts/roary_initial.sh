#!/bin/bash

# Set paths
DATA_PATH="/home/alvin/BIO511/Genomics_pipelines/ZS1B1_1_WGS_project/data/CuratedGFFfilesforRoary_ZS1B1-1"
RESULTS_PATH="/home/alvin/BIO511/Genomics_pipelines/ZS1B1_1_WGS_project/results/roary_pangenome"

cd $DATA_PATH

#------------[Running roary]-----------#
# "-e" is for doing a multiFASTA-alignment, "-p x" set the number of threads ("x") to dedicate to running roary, "-r" creates r-plots. "-f" is the output directory,
roary -e --mafft -p 15 -r -f ${RESULTS_PATH} ${DATA_PATH}/*.gff