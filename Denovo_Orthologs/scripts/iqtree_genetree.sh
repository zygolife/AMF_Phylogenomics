#!/usr/bin/bash
#SBATCH --ntasks 2 --nodes 1 --mem 2G --time 24:00:00 -p batch

module load IQ-TREE

for file in *.trim; 
do 
 iqtree-omp -s $file -b 100 -nt 2 
done
