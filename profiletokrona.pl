#! /usr/bin/perl
#
use strict;
use warnings;

my $file1=shift;
my $file2=shift;
my %hash;

open IN,$file1;
open OUT,">$file2";

while (<IN>){
	chomp;
	my $line=$_;
	next if ($line=~/^@/ || $line=~/^#/ || $line=~/^$/);
	my @array= split/\t/,$line;
	my @tax = split /\|/,$array[3];
	for (my $i=0;$i<@tax;$i++){
		if($hash{$tax[$i]}){
			if(@tax > $hash{$tax[$i]}){
				$hash{$tax[$i]}=@tax;
			}
		}else{
			$hash{$tax[$i]}=@tax;
		}
	}
}
close IN;

open IN,$file1;
while (<IN>){
	chomp;
	my $line=$_;
	next if ($line=~/^@/ || $line=~/^#/ || $line=~/^$/);
	my @array = split/\t/,$line;
	my @tax = split /\|/,$array[3];
	my $yidadui = join "\t",@tax;
	if ($hash{$tax[-1]} > @tax){
		next;
	}else{
		print OUT"$array[4]\t$yidadui\n";
	}
}
