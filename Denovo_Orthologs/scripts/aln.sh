#!/usr/bin/bash
module load muscle
module load trimal

perl -i -p -e 's/\*//' *.fa

for file in *.fa; 
do 

if [ ! -f $file.aln ]; then
 muscle -in $file -out $file.aln; 
fi

if [ ! -f $file.trim ]; then
 trimal -in $file.aln -out $file.trim -automated1
fi
done


