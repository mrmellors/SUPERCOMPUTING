# Assignment 6 - 03/17/2026 - Matt Mellors 

**Description:** This code will setup your directory, make scripts 

## Setup assignment_06 directory

Go to HPC and setup directory

```
cd SUPERCOMPUTING/assignments/assignment_06

mkdir -p scripts data assemblies/{assembly_conda,assembly_local,assembly_module}
```

## Download raw ONT data

Make script `nano ./scripts/01_download_data.sh`

Then add this to that file
```
#!/bin/bash
set -ueo pipefail

wget -O SRR33939694.fastq.gz "https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz?download=1"
gunzip SRR33939694.fastq.gz
```

Make the script executable `chmod +x ./scripts/01_download_data.sh`


## Get Flye v2.9.6 locally

Make script `nano ./scripts/flye_2.9.6_manual_build.sh`

```
#!/bin/bash
set -ueo pipefail

# go to programs
cd ~/programs

# compile flye
git clone https://github.com/fenderglass/Flye
cd Flye
make

#add to path so you can use it locally
echo 'export PATH=$PATH:/sciclone/home/mrmellors/programs/Flye/bin' >> ~/.bashrc
```

Make the script executable `chmod +x ./scripts/flye_2.9.6_manual_build.sh`

Also after running the script make sure to run `source ~/.bashrc` so that your path is updated


## Get Flye v2.9.6 using conda

Make script `nano ./scripts/flye_2.9.6_conda_install.sh`

```
#!/bin/bash
set -ueo pipefail

module load miniforge3

source "$(conda info --base)/etc/profile.d/conda.sh"

mamba create -y -n flye-env -c bioconda -c conda-forge flye=2.9.6

conda activate flye-env

conda env export --no-builds > flye-env.yml

conda deactivate
```

Make the script executable `chmod +x ./scripts/flye_2.9.6_conda_install.sh`


## Run Flye 3 ways

### Script to run Flye using conda

Make the script `nano ./scripts/02_run_flye_conda.sh`

```
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
```

Make the script executable `chmod +x ./scripts/02_run_flye_conda.sh`


### Script to run Flye with the module environment

Make the script `nano ./scripts/02_run_flye_module.sh`

```
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
```

Make the script executable `chmod +x ./scripts/02_run_flye_module.sh`


### Script to run Flye locally

Make the script `nano ./scripts/02_run_flye_local.sh`

```
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
```

Make the script executable `chmod +x ./scripts/02_run_flye_local.sh`


## Compare results in log files 

This bash code looks at the last 10 lines of each log file

```
tail -n 10 ./assemblies/assembly_conda/*log*
tail -n 10 ./assemblies/assembly_module/*log*
tail -n 10 ./assemblies/assembly_local/*log*
```

I turned it into a for loop so that it would be a little bit nicer 

```
for dir in assembly_conda assembly_module assembly_local; do
    echo "===== $dir ====="
    tail -n 10 ./assemblies/$dir/*log*
    echo
done
```

There is nothing different between the three log files besides it showing where the final assembly file lives in each respective directory.

## Write pipeline.sh script

Make pipeline.sh `nano pipeline.sh`

```
#!/bin/bash
set -ueo pipefail

# make sure we are in the correct spot
cd ~/SUPERCOMPUTING/assignments/assignment_06

# get data
./scripts/01_download_data.sh

# instal conda env as flye-env
./scripts/02_flye_2.9.6_conda_install.sh

# do local build of flye
./scripts/02_flye_2.9.6_manual_build.sh

export PATH="$PATH:/sciclone/home/mrmellors/programs/Flye/bin"

# run conda version of flye
./scripts/03_run_flye_conda.sh

# run local version of flye
./scripts/03_run_flye_local.sh

# run module version of flye
./scripts/03_run_flye_module.sh


#finally check the log files to make sure they are all the same

for dir in assembly_conda assembly_module assembly_local; do
    echo "===== $dir ====="
    tail -n 10 ./assemblies/$dir/*log*
    echo
done
```

Make sure the script is executable `chmod +x pipeline.sh`


Finally, you should run `./pipeline.sh` from you assignment_06 directory.


## Reflection

Overall, I think it was pretty straightforward. The only thing that tripped me up for a bit was getting things added to PATH with subshells opening. When I tried to use source ~/.bashrc, it wasn’t applying correctly, so I had to export the PATH within the pipeline instead. I think module load is the easiest option if it’s available. However, I’ll probably end up using conda the most, since there’s no guarantee that what I need will be available as a module.
