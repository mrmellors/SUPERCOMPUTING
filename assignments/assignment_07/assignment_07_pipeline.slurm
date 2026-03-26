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
