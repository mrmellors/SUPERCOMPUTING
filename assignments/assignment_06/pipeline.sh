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

