#!/bin/bash

module load miniforge3
source $(conda info --base)/etc/profile.d/conda.sh
conda activate assignment7

DATA_DIR=/sciclone/scr10/gzdata440/mrmellors

MAIN_DIR=~/SUPERCOMPUTING/assignments/assignment_07

files=$(cut -f1 -d "," ~/SUPERCOMPUTING/assignments/assignment_07/data/SraRunTable.csv | tail -n +2)

for SRA in $files
do
in1=${DATA_DIR}/${SRA}_1.clean.fastq.gz
in2=${DATA_DIR}/${SRA}_2.clean.fastq.gz
REF=${MAIN_DIR}/data/dog_reference/dog_reference_genome.fna


# Task 4: map reads to dog genome
bbmap.sh -Xmx64g \
in1=$in1 \
in2=$in2 \
ref=$REF \
out=${MAIN_DIR}/output/${SRA}.sam

# Task 5: extract only mapped reads
samtools view -F 4 -b \
${MAIN_DIR}/output/${SRA}.sam \
> ${MAIN_DIR}/output/${SRA}.dog_matches.sam

    
echo -n "$SRA: "
samtools view -c ${MAIN_DIR}/output/${SRA}.dog_matches.sam

done
