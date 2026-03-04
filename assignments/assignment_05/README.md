# Assignment 5 - 03/04/2026 - Matt Mellors

**Description:** This code will setup and run a pipeline that downloads fastq files, installs a program fastp, then writes a script to run fastp on a forward and reverse render of a sequence, and finally runs said script on every downloaded file.

## Setup assignment_05 directory 

Go to HPC and setup directory

```
cd SUPERCOMPUTING/assignments/assignment_05

mkdir -p scripts log data/{raw,trimmed}

```

## Make script to download and prep fastq data

`nano ./scripts/01_download_data.sh`

**In that file paste this code**

```
#!/bin/bas
set -ueo pipefail

cd ./data/raw

wget https://gzahn.github.io/data/fastq_examples.tar

tar -xf fastq_examples.tar

rm fastq_examples.tar
```

**Then outside of that file**
`chmod +x 01_download_data.sh`


## Install and explore the fastp tool

```
cd ~/programs

wget http://opengene.org/fastp/fastp

chmod +x ./fastp

```

I already have all of program added to my path, but you would have to do something like this:
`export PATH=$PATH:/sciclone/home/mrmellors/programs/fastq`


## Make script to run Fastq

`nano ./scripts/02_run_fastp.sh`

**In that file paste this code**

```

#defining main directory
MAIN_DIR="$HOME/SUPERCOMPUTING/assignments/assignment_05"

cd $MAIN_DIR

FWD_IN=$1
REV_IN=${FWD_IN/_R1_/_R2_}

FWD_OUT=${FWD_IN/.fastq.gz/.trimmed.fastq.gz}

REV_OUT=${REV_IN/.fastq.gz/.trimmed.fastq.gz}


fastp --in1 $FWD_IN --in2 $REV_IN --out1 ${FWD_OUT/raw/trimmed} --out2 ${REV_OUT/raw/trimmed} \
--json /dev/null \
--html ./log/${1#./data/raw/}.html \
--trim_front1 8 \
--trim_front2 8 \
--trim_tail1 20 \
--trim_tail2 20 \
--n_base_limit 0 \
--length_required 100 \
--average_qual 20

```

Also run `chmod +x ./scripts/02_run_fastp.sh`


## Make pipeline.sh script to run the entire pipeline

go back to main directory and create pipeline.sh

```
cd ~/SUPERCOMPUTING/assignments/assignment_05

nano pipeline.sh
```
**Paste in this code**

```
#!/bin/bash

# make sure in the right directory

MAIN_DIR=$HOME/SUPERCOMPUTING/assignments/assignment_05

cd $MAIN_DIR

# get data

./scripts/01_download_data.sh

# trim all of the files with fastq

for file in ./data/raw/*_R1_*;
do ./scripts/02_run_fastp.sh file;
done

```

run this line to make the pipeline executable `chmod +x pipeline.sh`

then finally run this line from the assignment_05 directory to run the pipeline `./pipeline.sh`


## Reflection

I had a little bit of trouble when coming up with this line of code `--html ./log/${1#./data/raw/}.html \` to get rid of the beginning of the path for the HTML file name. I tried doing `${1|./data/raw/|}`, but that wasn't working, so I asked ChatGPT and it gave me the line of code above that removes the specified prefix after the `#`.

I also learned how fastp works and what it can do. I don't know if I will ever use it again, but who knows.

We split it up into two scripts so that each script does its own specific job. It is better for debugging, as everything is much more compartmentalized. It doesn't make a big difference in this pipeline because it is small, but for one with many steps it will help keep things organized. A con could be deciding when and where to break off into a new script. It doesn't matter too much in the grand scheme of things as long as you try your best, but if you do it poorly it could be hard to follow.