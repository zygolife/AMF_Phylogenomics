#!/usr/bin/bash

perl scripts/combine_fasaln.pl -ext trim -o AMF.fasaln -of fasta \
 -d aln_outgroups -expected expected_names.txt > AMF.partitions.txt
