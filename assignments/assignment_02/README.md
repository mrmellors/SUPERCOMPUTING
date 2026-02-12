# Assignment 2 - Matthew Mellors - 2/11/2025

## Making data folder on HPC (HPC)

bora

$ cd SUPERCOMPUTING/assignments/assignment\_02

$ mkdir data

exit

## Getting data from http://ftp.ncbi.nlm.nih.gov (local)

cd ~

ftp ftp.ncbi.nlm.nih.gov

signed in with anonymous and email name as password

Had to reconnect with my hotspot because my apartment WIFI didn't like running commands within the gov server.

cd genomes/all/GCF/000/005/845/GCF\_000005845.2\_ASM584v2/

ls

get GCF\_000005845.2\_ASM584v2\_genomic.fna.gz

get GCF\_000005845.2\_ASM584v2\_genomic.gff.gz

bye

## Transferring files to HPC (HPC through sftp)

sftp mrmellors@bora.sciclone.wm.edu

cd SUPERCOMPUTING/assignments/assignment\_2/data

ls

put GCF\_\*

ls

bye

### Checking uploaded files are world readable (HPC)

bora

SUPERCOMPUTING/assignments/assignment\_02/data

ls -alh

It returned -rw-r----- for both of the uploaded files. The first rw means I the owner can read and write. The second r means the people in my group gzdata440 can read. The final dashes mean others (world) have no permissions. Everyone in the group can read it, but the instructions were asking if it was world readable, which it is not, so I will update it.

To make it world readable you do chmod o+r file name. The o stands for others (world) and the r gives read permissions. I also could have done something like this chmod o+rx directory_name. It will not mess with the . and .. in the directory.

chmod o+r GCF_*

ls -alh

It now returned -rw-r--r-- for both of the data files. Yay.

exit

## Verifying File Integrity with md5sum

### First checking locally

ls GCF* so I can copy paste

md5sum GCF*   I now realize I can do this and it will do both of them at once

c13d459b5caa702ff7e1f26fe44b8ad7 *GCF_000005845.2_ASM584v2_genomic.fna.gz
2238238dd39e11329547d26ab138be41 *GCF_000005845.2_ASM584v2_genomic.gff.gz

### Now checking on HPC 

bora 

cd SUPERCOMPUTING/assignments/assignment_02/data

ls 

md5sum GCF*

c13d459b5caa702ff7e1f26fe44b8ad7  GCF_000005845.2_ASM584v2_genomic.fna.gz
2238238dd39e11329547d26ab138be41  GCF_000005845.2_ASM584v2_genomic.gff.gz


**They are the same :)**

## Creating useful bash aliases

Still in HPC from last step 

cd ~

nano .bashrc

scroll down to aliases and paste the following 

alias u='cd ..;clear;pwd;ls -alFh --group-directories-first'
alias d='cd -;clear;pwd;ls -alFh --group-directories-first'
alias ll='ls -alFh --group-directories-first'


The alias **'u' is going to the parent directory**, clearing all outputs in the terminal, printing the working directory, and finally it shows all files (a) in long format (l) adds symbols (F) in human readable file sizes (h) and puts directories at the top. 

The alias **'d' is going to the previous directory**, clearing all outputs in the terminal, printing the working directory, and finally it shows all files (a) in long format (l) adds symbols (F) in human readable file sizes (h) and puts directories at the top. 

The alias **'ll'** shows all files (a) in long format (l) adds symbols (F) in human readable file sizes (h) and puts directories at the top. 


## Adding README.md to HPC because I'm a scaredy cat

sftp mrmellors@bora.sciclone.wm.edu

cd SUPERCOMPUTING/assignments/assignment_02

put README.md

ls

bye


## Then add commit push from HPC 

bora

cd SUPERCOMPUTING/

git status

git add assignment_02

git status

git commit -m "adding assignment_02"

git push

 

## Final Thoughts

It was a little bit messy figuring out what to do with files to not get a merge conflict. I had written everything my README on my local computer and just did a whole file transfer so that when I uploaded it all to GitHub it would just take one try. I can already see how it starts to become a pain keeping track of your version on the HPC and your local computer. I know it wouldn't have given me a merge conflict as long as I make sure to pull first, but I am assuming it would have wiped everything I had written in the README on my local computer.

I asked ChatGPT and it said that it wouldn't rewrite the README, it would pull new directories and files and then tell me there is a version conflict with the README. Finally I could add commit push from there. At least that is what I gleaned from it, I didn't want to test and find out.

Well it happened anyway so I added then commit and then pulled again. 

