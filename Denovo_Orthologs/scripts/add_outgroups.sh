#!/usr/bin/bash

module load cdbfasta
TARGET=aln_outgroups
IN=aln
DB=outgroup/allseq

mkdir -p $TARGET
if [ ! -f $DB.cidx ]; then
 cdbfasta $DB
fi

rm $TARGET/*.fa
rsync -a $IN/*.fa $TARGET/
for besthits in search/*.best;
do
 while read ORTH NAME SIGNIF;
 do
  echo "$ORTH $NAME $SIGNIF"
  echo "$NAME" | cdbyank $DB.cidx >> $TARGET/$ORTH.fa
 done < $besthits

done
