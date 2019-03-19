#!/usr/bin/env perl

# Downloaded from http://www.bioinformatics-made-simple.com




@input_files=();
$min_length=0;
$max_length=999999999999;
$treat_long=0;
$|=1;

###   CHECK COMMAND LINE ARGUMENTS   ###
if(@ARGV==0)
	{
	print"No arguments passed to the script!\nIf you entered arguments try the following command:\nperl length_cutoff.pl -argument1 -argument2 ...\n\n";
	exit;
	}

$argv="";
foreach(@ARGV)
	{
	$argv.=$_;
	}
@arguments=split('-',$argv);

foreach(@arguments)
	{
	if($_=~/^ *i/)
		{
		$_=~s/^ *i//;
		$_=~s/ //g;
		push(@input_files,$_);
		}
	elsif($_=~/^ *I/)
		{
		$_=~s/^ *I//;
		$_=~s/ //g;
		open(FILES_IN,"$_");
		while(<FILES_IN>)
			{
			unless($_=~/^\s*$/)
				{
				$_=~s/\s//sg;
				push(@input_files,$_);
				}
			}
		}
	elsif($_=~/^ *min/)
		{
		$_=~s/^ *min//;
		$_=~s/ //g;
		$min_length=$_;
		unless($min_length=~/^\d+$/)
			{
			print"Minimum sequence length has to be numerical!\n";
			exit;
			}
		}
	elsif($_=~/^ *max/)
		{
		$_=~s/^ *max//;
		$_=~s/ //g;
		$max_length=$_;
		unless($max_length=~/^\d+$/)
			{
			print"Maximum sequence length has to be numerical!\n";
			exit;
			}
		}
	elsif($_=~/^ *[01]/)
		{
		$_=~s/ *//g;
		$_=~s/ //g;
		$treat_long=$_;
		}
	elsif($_!~/^\s*$/)
		{
		print"Don't know how to treat argument $_!\nIt will be ignored.\n\n";
		}
	}
unless($min_length<=$max_length)
	{
	print"Maximum sequence length must be >= minimum seuquence length!\n";
	exit;
	}
if(@input_files==0)
	{
	print"No input file specified!\n";
	exit;
	}

###   PRINT ARGUMENTS   ###
print"The following files will be processed:\n";
foreach(@input_files)
	{
	if(-e $_)
		{
		print"$_\n";
		push(@input_files_ok,$_);
		}
	else
		{
		print"could not find file: $_. It will be ignored.\n";
		}
	}
print"Minimum seuquence length: $min_length\nMaximum seuquence length: $max_length\n";
if($treat_long==1)
	{
	print"Sequences exceeding maximum length will be clipped to proper size.\n\n";
	}

###   START   ###
open(OUT_OK,">sequences_ok.fas");
unless($treat_long==1)
	{
	open(OUT_LONG,">sequences_too_long.fas");
	}
open(OUT_SHORT,">sequences_too_short.fas");
$seqs_ok=0;
$seqs_long=0;
$seqs_short=0;
foreach$file(@input_files_ok)
	{
	print"processing $file";
	open(IN,$file);
	while(<IN>)
		{
		if($_=~/^>/)
			{
			$title=$_;
			}
		elsif($_!~/^\s*$/)
			{
			chomp$_;
			if(length$_>=$min_length)
				{
				if(length$_<=$max_length)
					{
					$seqs_ok++;
					print OUT_OK "$title$_\n";
					}
				elsif($treat_long==0)
					{
					$seqs_long++;
					print OUT_LONG "$title$_\n";
					}
				elsif($treat_long==1)
					{
					$_=substr($_,0,$max_length);
					$seqs_long++;
					print OUT_OK "$title$_\n";
					}
				}
			else
				{
				$seqs_short++;
				print OUT_SHORT "$title$_\n";
				}
			}
		}
	close IN;
	print" done.\n";
	}
close OUT_OK;
close OUT_LONG;
close OUT_SHORT;
print"Sequences with proper size:\t$seqs_ok\nSequences too long:\t\t$seqs_long\nSequences too short:\t\t$seqs_short\n\n";
exit;