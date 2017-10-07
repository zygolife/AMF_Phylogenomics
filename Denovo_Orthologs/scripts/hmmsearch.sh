#!/usr/bin/bash
#SBATCH --ntasks 4 --nodes 1 --mem 2G --time 2:00:00 -p short
module load hmmer/3

CPUS=4
OUT=search
if [ ! -d $OUT ]; then
 mkdir -p $OUT
fi
orthdb=Glomeromycotina.hmm

for outsp in outgroup/*.fasta;
 do
   sp=$(echo $outsp | perl -p -e 'my @n = split(/\./,$_); $_ = $n[1]."\n"')
   if [ ! -f $OUT/$sp.domtbl ]; then
    hmmsearch --cpu $CPUS -E 1e-40 --domtbl $OUT/$sp.domtbl $orthdb $outsp > $OUT/$sp.log
   fi
   if [ ! -f $OUT/$sp.best ]; then
    perl scripts/get_best_hmmtbl.pl search/$sp.domtbl > search/$sp.best
   fi
done
 
