#!/bin/bash
set -ueo pipefail

#go to data raw directory
cd ./data/raw

wget https://gzahn.github.io/data/fastq_examples.tar

#unpack fastq files from tarball
tar -xf fastq_examples.tar

#remove tarball
rm fastq_examples.tar
