#!/bin/bash

# Bash-script for initialising the "fastplong" conda-environment locally and running the initial fastplong analysis of the ONT-data for the ZS1B1-1 
# strain of Leeuwenhoekiella marinoflava. Created by Alvin Sundqvist on the 7th of October 2025. Last updated the 20th of October 2025.


#----------------[Setting optargs]----------------#
while getopts "m:h" opt; do
    case $opt in
        m) QC_MODE="$OPTARG" ;; # -m flag for choosing whether to use baseline fastplong options or use the extra filtering specied in this script
        h) echo -e "Usage: $0 -m 'baseline'/'filtered'" 
           exit 0 ;; # -help flag for getting help about the different optargs used in this script.
        *) echo "Invalid option specified: -$OPTARG" >&2
           exit 1 ;;
    esac
done
QC_MODE="${QC_MODE:-baseline}"
#-------------------------------------------------&


#---------------[Setting file-paths]--------------#
DATA_PATH="/home/alvin/BIO511/Genomics_pipelines/ZS1B1_1_WGS_project/data"
RESULTS_PATH="/home/alvin/BIO511/Genomics_pipelines/ZS1B1_1_WGS_project/results/fastplong_QC"
#-------------------------------------------------&


# Fetching today's date
CurrentDate=$(date -d today +"%d_%m_%Y")


#--------------[Running fastplong-tool]-----------#
cd $DATA_PATH
# "-i" is the input filepath, "-o" is the output filepath, "-h" is the .html-filepath for the report of the QC-results,
# "-j" is the .json-filepath for the report of the QC-results.

echo "Now running fastlong-tool on genome Z1B1-1"

# Baseline fastp
if [[ $QC_MODE == "baseline" ]]; then
    echo "Starting QC using the ${QC_MODE} mode."
    echo
    fastplong -i ${DATA_PATH}/ZS1B1-1_cat.fastq.gz \
     -o ${RESULTS_PATH}/baseline/${CurrentDate}_ZS1B1_1_initial_QC.fastq.gz \
     -h ${RESULTS_PATH}/baseline/${CurrentDate}_ZS1B1_1_initial_QC_report.html \
     -j ${RESULTS_PATH}/baseline/${CurrentDate}_ZS1B1_1_initial_QC_report.json \
     -V
    
    echo "QC finished."
fi


# fastp with stricter filtering and trimming.
if [[ $QC_MODE == "filtered" ]]; then
    echo "Starting quality control of ONT-reads using the ${QC_MODE} mode."
    echo
    # "--cut_front" defines that all parts of reads towards the tail from a sliding window inwhich the mean quality score is lower than a
    # threshold will be discarded,
    # "--cut_mean_quality" determines that trimming occurs only for reads with mean quality scores under 30, 
    # "--length_required" determines that reads shorter than a threshold are discarded and
    # "--length_limit" determines the maximum length of a read.

    fastplong -i ${DATA_PATH}/ZS1B1-1_cat.fastq.gz \
     -o ${RESULTS_PATH}/filtered/${CurrentDate}_ZS1B1-1_initial_QC_filtered.fastq.gz \
     -h ${RESULTS_PATH}/filtered/${CurrentDate}_ZS1B1-1_initial_QC_filtered_report.html \
     -j ${RESULTS_PATH}/filtered/${CurrentDate}_ZS1B1-1_initial_QC_filtered_report.json \
     -V \
     --cut_front --cut_mean_quality 30 --length_required 80 --length_limit 95000

    echo "Quality control of ONT-reads finished."
fi
#--------------------------------------------------&