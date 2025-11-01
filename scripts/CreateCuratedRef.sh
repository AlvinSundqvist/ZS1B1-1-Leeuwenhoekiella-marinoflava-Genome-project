#!/bin/bash

# Setting optargs for script
while getopts "s:f:t:p:h" opt; do
    case $opt in
        s) SOURCE_DIRECTORY="$OPTARG" ;;
        f) FINAL_DIRECTORY="$OPTARG" ;;
        t) FILE_TYPE="$OPTARG" ;;
        p) PREFIX="$OPTARG" ;;
        h) echo -e "Usage:\n -s 'path to directory containing raw, unfiltered files' \n -f 'final path to directory where curated reference will be' \n -t 'file-type of files for which a curated reference will be made' \n -p 'prefix in name of the final curated file' "
           exit 0 ;;
        *) echo "Invalid option specified: '-$OPTARG' Please see option '-h' for help with available options." >&2
           exit 1 ;;
    esac
done


# Checking for existence of choosen directory and correct type of file in the former
if [[ -z $SOURCE_DIRECTORY ]]; then
    echo "No source directory for files was given, exiting script."
    exit 1
fi

if [[ -e ${SOURCE_DIRECTORY}/*.${FILE_TYPE} ]]; then
    echo "No files ending with '.${FILE_TYPE}' were found in the directory '${SOURCE_DIRECTORY}'. Exiting script."
    exit 1
    else
    echo "u"
fi


#-----------------[Main Script]------------------#
if [[ 2 -eq 3 ]]; then
cd ${SOURCE_DIRECTORY}

# Create temporary merge-file and concatenate all files of a specific file-type into it
touch ${SOURCE_DIRECTORY}temp_merged_raw_${FILE_TYPE}
cat *.${FILE_TYPE} >> ${SOURCE_DIRECTORY}temp_${PREFIX}_merged_raw_${FILE_TYPE}

# Remove exact duplicate sequences using command 'rmdup' from tool 'seqkit'
seqkit rmdup -s -o ${SOURCE_DIRECTORY}temp_${PREFIX}_merged_dedup_${FILE_TYPE} ${SOURCE_DIRECTORY}temp_${PREFIX}_merged_raw_${FILE_TYPE}

# Cluster similar sequences at 95% identity to remove redundancy
cd-hit -i ${SOURCE_DIRECTORY}${PREFIX}_merged_dedup_${FILE_TYPE} -o ${FINAL_DIRECTORY}temp_${PREFIX}_CuratedRef.${FILE_TYPE} -c 0.95 -n 5 -d 0 -T 2 -M 0

rm ${SOURCE_DIRECTORY}temp_${PREFIX}_merged_raw_${FILE_TYPE}
rm ${SOURCE_DIRECTORY}temp_${PREFIX}_merged_dedup_${FILE_TYPE}

echo "Curated reference of type .${FILE_TYPE} has now been created"
fi