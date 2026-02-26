# Assignment 4 - 2/24/2026 - Matt Mellors

## Build bash script 

Login to HPC 

```
cd programs 

nano install_gh.sh

```

Building install script 

```
#!/bin/bash
set -ueo pipefail

# download file and unpack into programs

cd ~/programs

wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz

tar -xzvf gh_2.74.2_linux_amd64.tar.gz

# remove tarball

rm gh_2.74.2_linux_amd64.tar.gz

```

then run these two lines to run the script install_gh.sh

```
chmod +x install_gh.sh

install_gh.sh
```

## Modifying path variable
```
cd 

nano .bashrc

```

Paste this line into .bashrc

`export PATH=$PATH:/sciclone/home/mrmellors/programs/gh_2.74.2_linux_amd64/bin`

## Creating Installation Script for seqtk
```
cd programs

nano install_seqtk.sh
```

```
#!/bin/bash
set -ueo pipefail

# clone seqtk and unpack into programs

cd ~/programs

git clone https://github.com/lh3/seqtk.git

cd seqtk

# compile it 

make


# add seqtk to .bashrc

echo 'export PATH="$HOME/programs/seqtk:$PATH"' >> ~/.bashrc

```

To install seqtk 

```
chmod +x install_seqtk.sh

install_seqtk.sh

```

## Write summarize_fast.sh script 
```
cd SUPERCOMPUTING/assignments/assignment_04

nano summarize_fasta.sh
```

```
#!/bin/bash
set -ueo pipefail

file=$1

# total sequences (one line per sequence)
total_seqs=$(seqtk comp "$file" | wc -l)

# total nucleotides 
total_nt=$(grep -v "^>" "$file" | tr -d '\n' | wc -c)

# store table of name + length in variable
table=$(seqtk comp "$file" | cut -f1,2)


echo "Summary for: $file"
echo "----------------------------------"
echo "Total sequences: $total_seqs"
echo "Total nucleotides: $total_nt"
echo
echo -e "NAME\tLENGTH"
echo "$table" 

```

Run this to make summarize_fasta executable

```
chmod +x summarize_fasta.sh
```

## Run summarize_fasta.sh in a loop
```
for f in data/*.fasta; do
  echo "===== $f ====="
  ./summarize_fasta.sh "$f"
  echo
done
```

## Reflection

Overall, I felt like it was pretty straightforward, but it was definitely very useful. The main challenge I had was forgetting to run source .bashrc. I was running around in circles trying to figure out why seqtk wasn’t found anywhere, even though it had compiled correctly. One more was with exporting the path with seqtk. With " " it did a weird expansion of the PATH variable and messed it up. 

Some new things I learned were that you can assign the name of a file when using wget with the -O flag, along with the syntax for for loops and a little more about seqtk.

$PATH is just a variable that contains all of the directories Bash will search through when you type a command. Most commands are located in /usr/bin, but you can add another directory to $PATH, and Bash will search there when you try to run a program you created in that directory.