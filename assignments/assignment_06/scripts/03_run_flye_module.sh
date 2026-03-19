#!/bin/bash
set -ueo pipefail

# load Flye from modules

module load Flye/gcc-11.4.1/2.9.6

# run flye

flye \
  --nano-hq ./data/SRR33939694.fastq \
  --meta \
  --out-dir ./assemblies/assembly_module

# move into assembly_module to rename files

cd ./assemblies/assembly_module

mv assembly.fasta module_assembly.fasta

mv flye.log module_flye.log

# clean up assembly_module

find . -type f ! -name "module_assembly.fasta" ! -name "module_flye.log" -delete
find . -type d ! -name "." -delete

