#!/bin/bash

# Set paths
DATA_PATH="/home/alvin/BIO511/Genomics_pipelines/ZS1B1_1_WGS_project/data"
RESULTS_PATH="/home/alvin/BIO511/Genomics_pipelines/ZS1B1_1_WGS_project/results/AnnotationsOfInterest"
GENOMIC_ANNOTATION="${DATA_PATH}/25_10_2025_ZS1B1-1_prokka_Curated" # The directory containing ZS1B1-1 genome for input
PatternsOfInterest="${DATA_PATH}/PatternsOfInterest.txt" # Gene name patterns of interest. Put your keywords into this text-file re 
# Extracting base date from name of prokka-folder
BASE_DATE=$(basename ${GENOMIC_ANNOTATION} "_ZS1B1-1_prokka_Curated")

# Creating file for proteins with interesting names
cat > ${RESULTS_PATH}/${BASE_DATE}_ProteinsOfInterest.txt << 'EOF'
Protein names matching pattern of interest:

EOF

# Creating tab-separated file for summary of different annotation features
cat > ${RESULTS_PATH}/${BASE_DATE}_AnnotationSummary.tsv << 'EOF'
Annotation_feature  Number_of_feature
EOF

# Checking whether any annotations in the .ffn-file have names containing a pattern of interest, which are found in the "PatternsOfInterest". If so, 
# add its name to the file "ProteinsOfInterest.txt".
while IFS= read -r pattern; do
    NumberOfFeature=0
    NumberOfFeature=$(grep -c "${pattern}" ${GENOMIC_ANNOTATION}/ZS1B1-1.ffn)

    # Checking for prevalence of proteins of interest
    if [[ $pattern == "tRNA-...(...)$" ]] ; then
        echo "'tRNA': ${NumberOfFeature} hits in annotated ZS1B1-1 genome" >> ${RESULTS_PATH}/${BASE_DATE}_ProteinsOfInterest.txt
        grep -i "${pattern}" ${GENOMIC_ANNOTATION}/ZS1B1-1.ffn >> ${RESULTS_PATH}/${BASE_DATE}_ProteinsOfInterest.txt
        echo "" >> ${RESULTS_PATH}/${BASE_DATE}_ProteinsOfInterest.txt
    else
        echo "'${pattern}': ${NumberOfFeature} hits in annotated ZS1B1-1 genome" >> ${RESULTS_PATH}/${BASE_DATE}_ProteinsOfInterest.txt
        grep -i "${pattern}" ${GENOMIC_ANNOTATION}/ZS1B1-1.ffn >> ${RESULTS_PATH}/${BASE_DATE}_ProteinsOfInterest.txt
        echo "" >> ${RESULTS_PATH}/${BASE_DATE}_ProteinsOfInterest.txt
    fi

    # Checking how many instances of common annotation patterns are found in the .ffn-file.
    if [[ $pattern == "tRNA-...(...)$" ]] || [[ $pattern == "transfer-messenger RNA" ]] || [[ $pattern == "hypothetical protein" ]] || [[ $pattern == "putative protein" ]]; then
        if [[ $pattern == "tRNA-...(...)$" ]]; then
            echo -e "tRNA\t${NumberOfFeature}" >> ${RESULTS_PATH}/${BASE_DATE}_AnnotationSummary.tsv

        else
            echo -e "${pattern}\t${NumberOfFeature}" >> ${RESULTS_PATH}/${BASE_DATE}_AnnotationSummary.tsv
        fi
    fi
done < $PatternsOfInterest

echo -e "Coding domain sequences\t$(grep -c "^>" ${GENOMIC_ANNOTATION}/ZS1B1-1.ffn)"  >> ${RESULTS_PATH}/${BASE_DATE}_AnnotationSummary.tsv