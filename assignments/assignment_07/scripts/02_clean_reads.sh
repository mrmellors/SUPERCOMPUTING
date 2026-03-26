#!/bin/bash

module load miniforge3
source $(conda info --base)/etc/profile.d/conda.sh
conda activate assignment7

DIR=/sciclone/scr10/gzdata440/mrmellors

mkdir -p $CLEAN_DIR

files=$(cut -f1 -d "," ~/SUPERCOMPUTING/assignments/assignment_07/data/SraRunTable.csv | tail -n +2)

for SRA in $files
do
in1=${DIR}/${SRA}_1.fastq
in2=${DIR}/${SRA}_2.fastq
out1=${DIR}/${SRA}_1.clean.fastq
out2=${DIR}/${SRA}_2.clean.fastq

fastp \
--in1 $in1 \
--in2 $in2 \
--out1 $out1 \
--out2 $out2 \
--json dev/null \
--html dev/null
done
