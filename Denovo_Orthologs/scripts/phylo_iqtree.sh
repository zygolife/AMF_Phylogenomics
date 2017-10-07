#!/usr/bin/bash
#!/usr/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --job-name=IQTREE
#SBATCH --time=4-0:00:00
#SBATCH --mem 64G
#SBATCH --output=iqtree.%A.out

module load IQ-TREE

CPU=2

RUNFOLDER=phylo
if [ $SLURM_CPUS_ON_NODE ]; then
 CPU=$SLURM_CPUS_ON_NODE
fi

OUT=Morel1,Umbra1
IN=AMF.fasaln
PART=AMF.partitions.txt
datestr=`date +%Y_%b_%d`
str=AMF.$datestr
if [ ! -f phylo/$str.fasaln ]; then
 cp $IN phylo/$str.fasaln
fi
if [ ! -f phylo/$str.iqtree.partitions ]; then
 cp $PART phylo/$str.iqtree.partitions
 perl -i -p -e 's/^PROT/LG/' phylo/$str.iqtree.partitions
fi
cd phylo

iqtree-omp -s $str.fasaln -spp $str.iqtree.partitions -bb 1000 -nt AUTO
