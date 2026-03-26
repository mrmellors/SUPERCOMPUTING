# Assignment 7 - 03/25/2026 - Matt Mellors

Go to HPC and setup directory 

## Setup assignment_07 directory
```
cd SUPERCOMPUTING/assignments/assignment_07

mkdir -p scripts data/{clean,dog_reference,raw} output 
```

## Make Conda Env

Do this on the HPC before running pipeline and the scripts will activate the environment

```
module load miniforge3

conda create -n assignment7 -c conda-forge -c bioconda \
    sra-tools \
    ncbi-datasets-cli \
    fastp \
    bbmap \
    samtools -y

```

## Download Sequence Data

Make script 

`nano ./scripts/01_download_data.sh`

```
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
```

Then do `chmod +x ./scripts/01_download_data.sh`

## Clean up raw reads

Make script

`nano ./scripts/02_clean_reads.sh`

```
#!/bin/bash

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
```
Make the script executable as well `chmod +x ./scripts/02_clean_reads.sh`


## Map clean reads to dog genome

Make script `nano ./scripts/03_map_reads.sh`

```
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
```

Make it executable `chmod +x 03_map_reads.sh`


## Submit Job to SLURM

First make the SLURM file `nano assignment_07_pipeline.slurm`

```
#!/bin/bash
#SBATCH --job-name=assignment_07
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --time=30
#SBATCH --mem=64G
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=mrmellors@wm.edu
#SBATCH -o /sciclone/home/mrmellors/SUPERCOMPUTING/assignments/assignment_07/output/assignment_07_%j.out
#SBATCH -e /sciclone/home/mrmellors/SUPERCOMPUTING/assignments/assignment_07/output/assignment_07_%j.err

cd ~/SUPERCOMPUTING/assignments/assignment_07

./scripts/01_download_data.sh

./scripts/02_clean_reads.sh

./scripts/03_map_reads.sh
```

Then submit to SLURM `sbatch assignment_07_pipeline.slurm`


## Inspect output 

```
cat ./output/*.err
cat ./output/*.out
```

## Inspect Results

I couldn't get my data to download, so I could never run my slurm pipeline and have no results.


## Reflection

fasterq-dump was giving me the error **"Failed to call external services."**, and I couldn’t figure out how to get it to work. It didn’t work on my local build of fasterq-dump or in my conda environment, even though which fasterq-dump was returning a valid path. I never figured out how to resolve the issue, which was frustrating because I couldn’t run the rest of the pipeline. However, I think the rest of the scripts are logically correct.

I thought the issue might be related to using scr10, but it  didn’t work on the login node either. I know it didn't say to use scr10, but the SAR files I found looked pretty large.

I also learned that the SLURM headers have to go at the very top of the script. I had tried defining a variable like OUT_DIR before them, and that didn’t work.
