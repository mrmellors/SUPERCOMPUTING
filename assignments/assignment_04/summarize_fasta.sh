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
