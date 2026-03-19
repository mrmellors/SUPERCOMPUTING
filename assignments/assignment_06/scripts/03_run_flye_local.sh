#!/bin/bash
set -ueo pipefail

# run flye

flye \
  --nano-hq ./data/SRR33939694.fastq \
  --meta \
  --out-dir ./assemblies/assembly_local

# move into assembly_conda to rename files

cd ./assemblies/assembly_local

mv assembly.fasta local_assembly.fasta

mv flye.log local_flye.log

# clean up assembly_local

find . -type f ! -name "local_assembly.fasta" ! -name "local_flye.log" -delete
find . -type d ! -name "." -delete
