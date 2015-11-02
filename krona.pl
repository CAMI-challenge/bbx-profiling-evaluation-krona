#! /usr/bin/perl
#
use strict;
use warnings;
use Cwd 'abs_path';
use File::Basename;
use Pod::Usage;
use Getopt::Long;
use FindBin qw($Bin);

my ($_input,$_alias,$_output);
my ($input, $alias, $output );
my (@aliases,@inputs,$ktImportText);

GetOptions(
	"input=s" => \$_input,
	"alias=s" => \$_alias,
	"output=s"=> \$_output,
);

$input = defined $_input ? $_input : "NONE";
$alias = defined $_alias ? $_alias : "NONE";
$output = defined $_output ? $_output : "NONE";

# help message #
my $commands = << "USAGE";

krona plot for profiling result

Commands:

  -input    input profiling results, seperated by ",", e.g. cami1.txt;cami2.txt
  -alias    corresponding alias for input files, seperated by ","
  -output   output html file.

USAGE

# files #
if (defined $input && $input ne "NONE"){
	@inputs = split /\,/, $input;
}else{
	pod2usage(-verbose=>1, -msg=>$commands);
	exit(0);
}

# alias #
if (defined $alias && $alias ne "NONE"){
	@aliases = split /\,/, $alias;
}

# equal aliases #
if (@inputs != @aliases && $alias ne "NONE"){
	die "input file number should be equal to alias number!\n";
}

$output = abs_path($output);
my $outpath = dirname($output);

for (my $i=0;$i<@inputs;$i++){
	if ($alias ne "NONE" ){
		`perl $Bin/profiletokrona.pl $inputs[$i] $outpath/$aliases[$i].tsv`;
		$ktImportText .= " $outpath/$aliases[$i].tsv";
	}else{
		my $alias2 = basename($inputs[$i]);
		$alias2 =~ s/\.\w+//g;
		`perl $Bin/profiletokrona.pl $inputs[$i] $outpath/$alias2.tsv`;
		$ktImportText .= " $outpath/$alias2.tsv";
	}
}

my $krona = `which ktImportText`;
die "krona not installed, or not in your path" if $krona=~/^\/usr\/bin\/which/;
chomp($krona);

`$krona $ktImportText -o $output`;
