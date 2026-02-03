\# Supercomputing Assignment 01



\## Navigating to SUPERCOMPUTING folder from home



cd SUPERCOMPUTING

cd assignments/assignment\_01

ls \*\*| just checking if in the right place or not\*\*



\## Creating data directory and adding files



mkdir data

cd data

mkdir raw

mkdir clean

cd raw

touch statcast\_2025.csv

cd ../clean

touch velo\_leaderboard\_2025.csv

cd ../..



\## Creating scripts directory and adding file



mkdir scripts

cd scripts

touch salutations.py

echo "print('Good day to you fine sir')" > salutations.py \*\*| this writes the line to the python file\*\*

cd ..



\## Creating results directory and adding file



mkdir results

cd results

mkdir run\_01

cd run\_01

touch graph.png

cd ../..



\## Creating configs directory and adding file



mkdir configs

cd configs

touch config\_train\_svm.py

cd ..



\## Creating log directory and adding file



mkdir logs

cd logs

touch 02-01-2025\_log.txt

cd ..



\## Create assignment\_01\_essay.md



touch assignment\_01\_essay.md





\## Add Commit Push



git status checking what would be added

git add . \*\*| readding everything to the next commit because I don't want to type out each file\*\*

git status \*\*| rechecking what is to be added\*\*

git commit -m "First Assignment\_01 directory and essay commit" \*\*| committing the add\*\*

git push \*\*| pushing to the GitHub repository\*\*

