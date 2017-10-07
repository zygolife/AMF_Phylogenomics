#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
my $dbdir = 'pep';
my $out = 'aln';
my $force = 0;
my $cdbfasta = `which cdbfasta`;
chomp($cdbfasta);
my $cdbyank = `which cdbyank`;
chomp($cdbyank);
my $debug = 0;

GetOptions('db:s'  => \$dbdir,
	   'o|out:s' => \$out,
	   'force!'  => \$force,
	   'cdbfasta:s' => \$cdbfasta,
	   'cdbyank:s'  => \$cdbyank);

if ( ! $cdbfasta || ! -f $cdbfasta || ! -x $cdbfasta ) {
    die("need a cdbfasta - did you 'module load cdbfasta'");
}

while(<>) {
    chomp;
    my ($t1, $hits) = split(/\t/,$_);
    my ($id) = split(/\s+/,$t1);
    my $ofile = "$out/$id.fa";
    if( -f $ofile ) {
	warn("$ofile already exists will not overwrite");
	next;
    } else {
	unlink($ofile);
    }
    for my $hit ( split(/\s+/,$hits) ) {
	next if $hit =~ /^\s+$/;
	warn("hit is $hit\n") if $debug;
	if ( $hit =~ /(\S+)\(([^)]+)\)/ ) {
	    my ($gene,$db) = ($1,$2);
	    my $dbindex = "$dbdir/$db.pep.cidx";
	    if( ! -f "$dbindex"  ) {
		if ( ! -f "$dbdir/$db.pep") {
		    die "no $dbdir/$db.pep file?";
		}
		`$cdbfasta $dbdir/$db.pep`;
	    }
	    open (my $fh => "| cdbyank $dbindex | perl -p -e 's/^>/>$db|/' >> $ofile") || die $!;
	    print $fh $gene,"\n";
	}
    }

}
