#! /usr/bin/perl
use warnings;
use strict;
use Text::Wrap;

## Program Info:
#
# Name:  cutseq_fasta
#
# Function: Takes a fasta file and cuts a subset of sequences to make
#   a second fasta file.  Useful for pulling subsets of sequences from
#   larger ones.  Optionally, it will reverse-complement sequences.
#
# Author: John Nash
#  Copyright (c) Government of Canada, 2000-2011,
#  all rights reserved.
#
# Licence: This script may be used freely as long as no fee is charged
#    for use, and as long as the author/copyright attributions
#    are not removed.
#
# History:
#   Version 1.0 (June 25, 2001): first non-beta release.
#   Version 1.1 (October 6, 2005):
#     Accommodates multiple fasta files.
#     Added more snipping parameters.
#     Remove reverse translation.
#   Version 1.2 (November 8, 2011):
#     Need a 'clip from the rear' parameter.
#     $title -x: or $title -x will clip the last x bases frmo the end.
#     Format for PHAC as I am not at NRC any more.
#     This version should be deleted as it is buggy with respect to range determination!
#   Version 1.3 (January 23, 2012)
#     Bug fixes for range parameters.
#     $title -r x: is the same as $title -r x.
#     $title -r -x: is the same as $title -r -x.
#     $title -r :-x will clip from base 1 to -x bases from the end.
#
##

my $title = "cutseq_fasta";
my $version = "1.3";
my $date = "23 January, 2013";
$Text::Wrap::columns = 65;

# Error message:
my $error_msg = "Type \"$title -h\" for help.";

# Get and process the command line params:
# Returns array of $fasta_file and $orf_file;

my @cmd_line = process_command_line();
my $range = $cmd_line[0];
my $split = $cmd_line[1];
my $chunk = $cmd_line[2];

## Read in the sequence from a FASTA file:
my $seq_name;
my %seq_str;

# Read in each sequence:
while (<>) {
# Substitutes DOS textfile carriage returns with Unix ones:
  s/\r\n/\n/g;
  chomp;

# If the line begins with a ">", it's a comment field.
# Therefore we need the name:
  if (/^>/)  {  
    $_ = substr($_, 1, length $_);
    my @temp = split / /;
    $_ = $temp[0];
# remove trailing spaces from name:
    s/ $//g;
    $seq_name = $_
  }
  else {
    $seq_str{$seq_name} .= lc $_;
  }
} # end of while

foreach (sort keys %seq_str) {
  my $seq_length = length $seq_str{$_};

## handle $range:
  if ($range ne '') {
    
# assign them default values to be parsed into later:
    my $low_cut_val;
    my $high_cut_val;
    my $reverse_flag = "no";

# Read the incoming range values:
# x:y is a valid range
# x: will be defined as x to end
# :y will be defined as start to y
# y:x (y bigger than x) will do a reverse-complemented cut
# -x: (minus x) will be defined as the last x bases of the sequence


# split the range to the min and max values:
    my ($low_cut_tmp, $high_cut_tmp) = split /:/, $range;

# Check for a colon delimiter:
      if ($range !~ /:/) {
	$low_cut_tmp = $range;
	$high_cut_tmp = '';
      }

# fill in the blanks and check illegal ranges:
    if ($low_cut_tmp eq '') {
      $low_cut_val = 1;
     }
    elsif ($low_cut_tmp < 0) {
      $low_cut_val = $seq_length + $low_cut_tmp + 1;
    }
    else {
      $low_cut_val = $low_cut_tmp;
    }

    if ($high_cut_tmp eq '') {
      $high_cut_val = $seq_length;
    }
    elsif ($high_cut_tmp > $seq_length) {
      $high_cut_val = $seq_length;
    }
    elsif ($high_cut_tmp < 0) {
      $high_cut_val = $seq_length + $high_cut_tmp + 1;
    }
    else {
      $high_cut_val = $high_cut_tmp;
    }

# handle the reverse-complementation parameters:
    if ($low_cut_val >= $high_cut_val)  {
      $reverse_flag = "yes";
      ($low_cut_val, $high_cut_val) = ($high_cut_val, $low_cut_val);
    }
 
# don't allow $low_cut_val to be greater than or equal to $high_cut_val
    if ($low_cut_val >= $high_cut_val)  {
      die("\nError: $range too big for the sequence of $seq_length bases\n",
	  $error_msg,"\n");
    }

#  Cut $range from $seq_str to form $newseq_str
    my $newseq_str = substr($seq_str{$_}, ($low_cut_val -1), 
			    $high_cut_val - $low_cut_val + 1);
    my $diff = ($high_cut_val - $low_cut_val + 1);

# Print header and cut sequence:
    if ($reverse_flag eq "no")  {
      print ">$_","_",$low_cut_val,"_",$high_cut_val," ($diff)\n";
      print wrap('', '', "$newseq_str\n");
    }

    else {
      print ">$_", "_", $high_cut_val, "_", $low_cut_val, " ($diff)\n";

#   reverse the string:
      $newseq_str = reverse($newseq_str);
#   then complement it:
      $newseq_str =~ tr/xnatgcbdkrvhmysw[]/xntacgvhmybdkrws][/;
      print wrap('', '', "$newseq_str\n");
    } # end of "reverse" else 
  } # end of "range" code


## chunk code:
  if ($chunk ne '') {
    my ($low_chunk, $high_chunk);
    
# check for illegal characters, e.g. car:truck:
    if ($chunk !~ /^[0-9]+$/)  {
      die("\nError: $chunk is an incorrect -c parameter.\n",
	  $error_msg,"\n");
    }

# Generate the chunks:
    for (my $k = 1; $k <= $seq_length; $k+= $chunk ) {
      $low_chunk = $k;
      $high_chunk = $k+$chunk  < $seq_length ? $k+$chunk-1: $seq_length;

#  Cut $chunk from $seq_str to form $newseq_str
      my $newseq_str = substr($seq_str{$_}, ($low_chunk -1), 
			      $high_chunk - $low_chunk + 1);
      my $diff = ($high_chunk - $low_chunk + 1);

# Print header and split sequence:
      print ">$_","_",$low_chunk,"_",$high_chunk," ($diff)\n";
      print wrap('', '', "$newseq_str\n");

    } # end of for loop
  } # end of chunk's code


## split code:
  if ($split ne '') {
    my ($low_split, $high_split);
    
# check for illegal characters, e.g. car:truck:
    if ($split !~ /^[0-9]+$/)  {
      die("\nError: $split is an incorrect -s parameter.\n",
	  $error_msg,"\n");
    }

    next if $split == 0;

    my $split_size = int $seq_length/$split + 1;


# Generate the splits:
    for (my $k = 1; $k <= $seq_length; $k+= $split_size ) {
      $low_split = $k;
      $high_split = $k+$split_size  < $seq_length ? 
	$k+$split_size-1: 
	$seq_length;

      next if ($high_split <= $low_split);

#  Cut $split_size from $seq_str to form $newseq_str
      my $newseq_str = substr($seq_str{$_}, ($low_split -1), 
			      $high_split - $low_split + 1);
      my $diff = ($high_split - $low_split + 1);

# Print header and split sequence:
      print ">$_","_",$low_split,"_",$high_split," ($diff)\n";
      print wrap('', '', "$newseq_str\n");

    }

  } # end of split's code


} # end of foreach

### end of main:


##### SUBROUTINES:
sub process_command_line {
#
# Expects: 
# Returns: @cmd_line = ($range, $split, $chunk)
# Uses:
	
# Variables:
  my %opts = ();    # command line params, as entered by user
  my @cmd_line;  # returned value
  my @list;         # %opts as an array for handling
  my $cmd_args;	    # return value for getopts()
	
# Holders for command line's files:
  my $range = '';
  my $split = '';
  my $chunk = '';
  
# Scratch:
  my $item;
	
# Get the command=line parameters:
  use vars qw($opt_r $opt_s $opt_c $opt_h);
  use Getopt::Std;
  $cmd_args = getopts('r:s:c:h', \%opts);
	
# Die on illegal argument list:
  if ($cmd_args == 0) {
    die ("Error: Missing or incorrect command line parameter(s)!\n",
         $error_msg, "\n");
  }
	
# Check and enact each command-line argument:
  if (!%opts)  {
    help();
#    die ($error_msg, "\n");
  }
	
# Make the hashes into an array:
  @list = keys %opts;
	
# Do a quick check for "help" and the compulsory parameters:
#   If the compulsory files are not there, squawk and die:
  foreach $item (@list)  {
# Help:
    if ($item eq "h")  {
      help();
    }
# range:
    elsif ($item eq "r") {
      $range = $opts{$item};
    }
# split 
    elsif ($item eq "s") {
      $split = $opts{$item};
    }
# chunk
    elsif ($item eq "c") {
      $chunk = $opts{$item};
    }
  }
  
# Put it in an array:
	@cmd_line = ($range, $split, $chunk);
	return @cmd_line;
	
} #end of sub process_command_line()

sub help {
	
print <<EOHelp;
$title, version $version, $date

Function:  Takes a large fasta file and cuts a subset of sequences to 
   make a second fasta file. The program reads the fasta file from 
   standard input.  Multiple fasta files will work.

Syntax:  $title -r range x:y fasta_file
  where x:y is a range of co-ordinates (min:max) to be cut.

\"$title -r x:y fasta_file\"
  will cut sequences from co-ordinate x to co-ordinate y.
  If x is bigger than y, it will reverse_complement the sequence.

\"$title -r x: fasta_file\" 
  will cut sequence from co-ord x to the end of the sequence. Here, the colon
  (:) is optional.

\"$title -r -x: fasta_file\" 
  will cut sequence from the last x bases up to the end, i.e.
  \"$title -r -1000: fasta_file\" will give the last 1000 bases. Here, the colon
  (:) is optional.
  
\"$title -r :-x fasta_file\" 
  will cut sequence from the first base up to x bases from the end.

OR    $title -c number fasta_file
  where number is the size of chunk the file is to be split into. 

\"$title -c 200 fasta_file\"
  will split every entry into 200 nt pieces, plus any trailing smaller piece.

OR    $title -s number fasta_file
  where number is the number of pieces that the file is to be split into. 

\"$title -s2 fasta_file\"
  will split every entry into 2 equal pieces.

OR    $title -h for help.

Input is captured from stdin, so the program can be a pipe.

Output is written to stdout, so it can be captured to a file, e.g.
   $title -r 250:350 large_sequence.fasta > subset.fasta
or
   $title -r 250:350 < large_sequence.fasta > subset.fasta

Warning:  No attempt is made to ensure that the input file is a valid FASTA file

EOHelp
die ("\n");
} # end of sub help
