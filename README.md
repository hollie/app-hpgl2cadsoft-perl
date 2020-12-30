[![Actions Status](https://github.com/hollie/app-hpgl2cadsoft-perl/workflows/CI%20on%20master/badge.svg)](https://github.com/hollie/app-hpgl2cadsoft-perl/actions)
[![CPAN Cover Status](https://cpancoverbadge.perl-services.de/App-HPGL2Cadsoft-0.01)](https://cpancoverbadge.perl-services.de/App-HPGL2Cadsoft-0.01)

# SYNOPSIS

my $object = App::HPGL2Cadsoft->new(input\_file => 'logo.hpgl', output\_file => 'logo.scr', scaling\_factor => 342);

# DESCRIPTION

This module enables conversion of a HPGL graphical file into a script that can be imported
in the Cadsoft Eagle printed circuit board design tool.

# METHODS

## `new(%parameters)`

This constructor returns a new App::HPGL2Cadsoft object. Supported parameters are listed below

- input\_file

    This is a required parameter that contains the name of the HPGL file that needs to be converted to a Cadsoft Eagle script.

    &#x3d; item output\_file

    This is a required parameter that contains the name of the output script

- scaling\_factor

    The scaling factor to apply on the HPGL script to convert the script to millimeters. Use this factor to make the
    Cadsoft Eagle output smaller or larger.
    To help you in selecting the correct scaling factor this module will report the bounding box of the output.

## `run()`

This function runs all steps required to read and scale the HPGL input file and to write the output to the 
Cadsoft Eagle script.

## BUILD

Helper function to run custome code after the object has been created by Moose.
