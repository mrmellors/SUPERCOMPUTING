#!/bin/bash

module load miniforge3/
source "$(conda info --base)/etc/profile.d/conda.sh"

conda activate assignment7

cd /sciclone/scr10/gzdata440/mrmellors/



files=$(cut -f1 -d "," ~/SUPERCOMPUTING/assignments/assignment_07/data/SraRunTable.csv | tail -n +2)

for SRA in $files
do
fasterq-dump --split-files -X 500000 $SRA
done

cd ~/SUPERCOMPUTING/assignments/assignment_07/data/dog_reference

datasets download genome taxon 9615 \
    --reference \
    --include genome \
    --filename dog_reference_genome.zip

unzip dog_reference_genome.zip -d dog_reference_genome

# Find the .fna file wherever it landed and rename it
find dog_reference_genome/ -name "*.fna" -exec mv {} ./dog_reference_genome.fna \;

# Clean up the zip and extracted folder
rm -rf dog_reference_genome dog_reference_genome.zip
