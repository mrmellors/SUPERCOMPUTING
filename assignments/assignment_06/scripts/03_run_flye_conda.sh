#!/bin/bash
set -ueo pipefail

# load flye conda environment

module load miniforge3
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate flye-env

# run flye

flye \
  --nano-hq ./data/SRR33939694.fastq \
  --meta \
  --out-dir ./assemblies/assembly_conda

# move into assembly_conda to rename files

cd ./assemblies/assembly_conda

mv assembly.fasta conda_assembly.fasta

mv flye.log conda_flye.log

# clean up assembly_conda

find . -type f ! -name "conda_assembly.fasta" ! -name "conda_flye.log" -delete
find . -type d ! -name "." -delete

conda deactivate
