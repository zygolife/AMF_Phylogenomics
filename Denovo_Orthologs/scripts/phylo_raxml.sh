#!/usr/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --job-name=RAXML
#SBATCH --time=4-0:00:00
#SBATCH --mem 64G
#SBATCH --output=RAXML.%A.out

module load RAxML

CPU=2

RUNFOLDER=phylo
if [ $SLURM_CPUS_ON_NODE ]; then
 CPU=$SLURM_CPUS_ON_NODE
fi

IN=AMF.fasaln
PART=AMF.partitions.txt
OUT=Morel1,Umbra1
datestr=`date +%Y_%b_%d`
str=AMF.$datestr
if [ ! -f phylo/$str.fasaln ]; then
 cp $IN phylo/$str.fasaln
 cp $PART phylo/$str.partitions
fi
cd phylo
raxmlHPC-PTHREADS-AVX -T $CPU -f a -x 227 -p 771 -o $OUT -m PROTGAMMALG -s $str.fasaln -n $str -N autoMRE -q $str.partitions
