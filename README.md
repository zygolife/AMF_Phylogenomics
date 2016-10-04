This is workflow for Phylogenomic analyses performed to support 
AMF Phylogenomics project

The steps to run this are outlined as follows. The protein datasets from JGI and other sources are included in this release.

This will require the external tools be installed
* Bioperl Perl libraries - http://bioperl.org/
* CDBFASTA - https://sourceforge.net/projects/cdbfasta/
* HMMER3 - http://hmmer.org/
* RAxML - https://github.com/stamatak/standard-RAxML
* trimAl - http://trimal.cgenomics.org/

Currently the system is setup for use with PBS so jobs that are run as arrayjobs expect PBS_ARRAYID variable to be set. This can be altered for slurm or sge or jobs all respond to a command line provided numeric argument

Step 1 - HMMsearch
==================
```
$ qsub -d. -t 1-10 jobs/01_hmmsearch.sh
# OR
$ for n in `seq 1 1 10`; do bash jobs/01_hmmsearch.sh $n; done
```

This will generate per-datafile set of HMMsearch results for all the
markers based on the marker HMMs in the HMM folder. By default this is
set in the config.txt file as 'JGI_1086' which are part of the set of
single copy genes generated by JGI team members for the
[1KFG](http://1000.fungalgenomes.org) project HMM marker set and
available in this repository
https://github.com/1KFG/Phylogenomics_HMMs. These are already a
submodule of this release so you do not need to do anything special
after checking it out. Will create files in search/$HMM or
search/JGI_1086 by default.

Step 2 - Choose best hit
=======================
```
$ bash jobs/02_makebesthits.sh
```
Selects top hitting protein model for each HMM.

Step 3 - generate fasta files of each orthologous marker set
============================================================
```
$ bash jobs/03_makeunaln.sh
```
Requires cdbfasta to work, will create files in aln/$HMM where HMM is the marker set (JGI_1086).

Step 4 - Align these orthologous genes
======================================
This can be run with pbs/sge/slurm. On our system it is run as
```
$ qsub -d. -t 1-434 jobs/04_hmmalign.sh
# OR if you only have a serial system
$ for n in `seq 1 1 434`; do bash jobs/04_hmmalign.sh $n; done
````

Note that the marker files to be processed are in the alnlist.$HMM
file (e.g. alnlist.JGI_1086) if you want to know the order of which
job/ID to the actual marker file being processed.

There is also a script to use muscle for de novo alignments which in some cases may be slightly more accurate (but slower for larger sampling 
Step 5 - Concatenated alignment
===============================
```
$ bash jobs/05_combine.sh
```

Alternative steps here could include running
`05_combine_randomsubset.sh` which sub-samples random markers (50 by default, but adjustable)

Step 6 - Build trees
====================
On our cluster we run it this way, but many alternatives depending on setup
```
$ qsub -l nodes=1:ppn=32,mem=24gb -q highmem 06_raxml_standardBootstrap.sh
```

I'm using raxml-PTHREADS-AVX but other systems with MPI or only SSE3
chipsets might be appropriate.

Step 7 - fix names in tree
==========================
Rename the taxa in the tree to long names
```
$ cd phylo
$ perl ../scripts/rename_tree_nodes.pl RAxML_bipartitions.Standard.Bifiguratus.2016_Oct_03.JGI1086.10sp ../prefix.tab > Bifiguratus.2016_Oct_03.JGI1086.10sp.tre
```
