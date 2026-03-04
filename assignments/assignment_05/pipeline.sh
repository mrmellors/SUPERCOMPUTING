#!/bin/bash

# make sure in the right directory

MAIN_DIR=$HOME/SUPERCOMPUTING/assignments/assignment_05

cd $MAIN_DIR

# get data

./scripts/01_download_data.sh

# trim all of the files with fastq

for f in ./data/raw/*_R1_*;
do ./scripts/02_run_fastp.sh $f;
done


