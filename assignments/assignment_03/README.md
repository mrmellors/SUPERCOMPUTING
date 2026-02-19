# Assignment 3 - Matthew Mellors - 2/18/2025



## Directory Structure 



assingment_03



	/data

		GCF\_000001735.4\_TAIR10.1\_genomic.fna.gz



## Getting data



cd SUPERCOMPUTING/assignments/assignment_03



mkdir data 



cd data



wget https://gzahn.github.io/data/GCF_000001735.4_TAIR10.1_genomic.fna.gz



gunzip GCF_000001735.4_TAIR10.1_genomic.fna.gz



ls



## Unix Commands



cat GCF_000001735.4_TAIR10.1_genomic.fna.gz    haha don't recommend



ctr + c



clear





### 1. How many sequences are in the FASTA file? (answer=7)



**Ans: grep "^>" GCF* | wc -l **



### 2. What is the total number of nucleotides (not including header lines or newlines)? (answer=119,668,634)



**Ans: grep -v "^>" GCF* | tr -d "\n" | wc -c **



### 3. How many total lines are in the file? (answer=14)



**Ans: wc -l GCF* **



### 4. How many header lines contain the word "mitochondrion"? (answer=1)



**Ans: grep "^>" GCF* | grep "mitochondrion" | wc -l **



### 5. How many header lines contain the word "chromosome"? (answer=5)



**Ans: grep "^>" GCF* | grep "chromosome" | wc -l**



### 6. How many nucleotides are in each of the first 3 chromosome sequences? (answer=30,427,672   19,698,290  23,459,831)



** A better answer after completing question 10 



paste <(grep "^>" GCF*) <(grep -v "^>" GCF*) | grep "chromosome 1" | cut -f2 | wc -c



paste <(grep "^>" GCF*) <(grep -v "^>" GCF*) | grep "chromosome 2" | cut -f2 | wc -c



paste <(grep "^>" GCF*) <(grep -v "^>" GCF*) | grep "chromosome 3" | cut -f2 | wc -c

**





Janky (but technically correct) Ans: 



threeline=$(head -n 3 GCF* | grep -v "^>" | wc -c)

fiveline=$(head -n 5 GCF* | grep -v "^>" | wc -c)

sevenline=$(head -n 7 GCF* | grep -v "^>" | wc -c)



echo ${threeline} 



echo $(( ${fiveline} - ${threeline} ))



echo $(( ${sevenline} - ${fiveline} ))







### 7. How many nucleotides are in the sequence for 'chromosome 5'? (answer=26,975,503)



** A better answer after completing question 10 



paste <(grep "^>" GCF*) <(grep -v "^>" GCF*) | grep "chromosome 5" | cut -f2 | wc -c



**



Janky Ans: 



elevenline=$(head -n 11 GCF* | grep -v "^>" | wc -c)

nineline=$(head -n 9 GCF* | grep -v "^>" | wc -c)



echo $(( ${elevenline} - ${nineline} ))





### 8. How many sequences contain "AAAAAAAAAAAAAAAA"? (answer=1)



**Ans: grep "AAAAAAAAAAAAAAAA" GCF* | wc -l**



### 9. If you were to sort the sequences alphabetically, which sequence (header) would be first in that list? (answer=>NC_000932.1...)



**Ans: grep "^>" GCF* | sort | head -n 1 **



### 10. How would you make a new tab-separated version of this file, where the first column is the headers and the second column are the associated sequences? (show the command(s))



>NC_003070.9 Arabidopsis thaliana chromosome 1 sequence    ccctaaaccctaaaccctaaaccctaaacctctG...

>NC_003071.7 Arabidopsis thaliana chromosome 2, partial sequence    NNNNNNNNNNNNNNNNNNNNNNN...

... etc.



**Ans:  paste <(grep "^>" GCF*) <(grep -v "^>" GCF*) **





## Reflection



I think my approach was pretty simple for most of the problems. For the most part I stuck to the basic grep and other commands we used in class. The cut and paste programs seem pretty useful for getting data into the format you want to then work with in Python. The hardest questions for me were definitely questions 6 and 7. I found a pretty janky way to get it at first, but after I completed question 10, I remembered you could pull from the columns. From there I found a much cleaner and more reproducible way to get the answer. Working with these programs and chaining them together is exactly like coding and logic puzzles, where there are many ways to get to the same answer. Unfortunately it is also the same in the sense that you can just get completely stuck at times. Sometimes there are much easier ways to complete a task, but you go down a rabbit hole and never get your way back up, like I did on problems 6 and 7. It reinforces the idea to just step away and do something else so your brain can reset and find a different angle of approach. 



They seem really good for ridiculous amounts of data because of how quickly each program runs even when chained together. In class you mentioned that when you do a command substitution and it is treated as a temporary file, it doesn't take up storage space and it runs just as quickly. Obviously, if you have a lot of data, that can be super useful when it comes to reformatting a lot of data quickly. Also, being able to build a pipeline with these Unix commands by chaining them together with Python or R scripts would be really useful as well. 

