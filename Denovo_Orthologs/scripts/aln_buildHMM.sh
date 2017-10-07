#!/usr/bin/bash
module load muscle
module load hmmer

perl -i -p -e 's/\*//' *.fa

for file in *.fa; 
do 

if [ ! -f $file.aln ]; then
 muscle -in $file -out $file.aln; 
fi
m=$(basename $file .fa)
esl-reformat stockholm $file.aln > $m.stk
hmmbuild $m.hmm $m.stk

done


