#! /usr/bin/env perl

use strict;
use Modern::Perl;

use App::HPGL2Cadsoft;
use Getopt::Long;
use Pod::Usage;

my ( $infile, $outfile, $scaling, $help, $man);

GetOptions(
    'input=s' =>   \$infile,
    'output=s'  => \$outfile,
    'scaling=s' => \$scaling,
    'help|?|h' =>  \$help,
    'man'      =>  \$man,
) or pod2usage(2);
pod2usage(1)
  if ( $help || !defined($infile) );
pod2usage( -exitstatus => 0, -verbose => 2 ) if ($man);

my $convertor = App::HPGL2Cadsoft->new(
    input_file => $infile,
    output_file => $outfile,
    scaling_factor => $scaling
);
$convertor->run();

# Abstract: program to convert a HPGL graphical file into a Cadsoft Eagle script for importing into your PCB

=head1 SYNOPSIS

Converts a HPGL file into a Cadsoft Eagle script. Usage:

    hpgl2cadsoft.pl <inputfile.hpgl> <outputfile.scr> <scalingfactor>

=head1 DESCRIPTION

This program converts a graphical file in HPGL format into a script file that you can run
in the Cadsoft Eagle board editor to import the graphic into your board file.

It allows you to scale the output by using a different scaling factor. 


