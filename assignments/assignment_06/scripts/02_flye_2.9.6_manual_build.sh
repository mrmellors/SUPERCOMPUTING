#!/bin/bash
set -ueo pipefail

# go to programs
cd ~/programs 

# compile flye
git clone https://github.com/fenderglass/Flye
cd Flye
make

#add to path so you can use it locally
#something was wrong when I tried to source within the pipeline script so I have this commented out.
# echo 'export PATH=$PATH:/sciclone/home/mrmellors/programs/Flye/bin' >> ~/.bashrc

