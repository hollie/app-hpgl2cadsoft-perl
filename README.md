[![Build status](https://travis-ci.org/hollie/app-hpgl2cadsoft-perl.svg?branch=releases)](https://travis-ci.org/hollie/app-hpgl2cadsoft-perl)

NAME
    App::HPGL2Cadsoft - module to convert a HPGL file into a Cadsoft Eagle
    script

VERSION
    version 0.01

SYNOPSIS
    my $object = App::HPGL2Cadsoft->new(input_file => 'logo.hpgl',
    output_file => 'logo.scr', scaling_factor => 342);

DESCRIPTION
    This module enables conversion of a HPGL graphical file into a script
    that can be imported in the Cadsoft Eagle printed circuit board design
    tool.

METHODS
  "new(%parameters)"
    This constructor returns a new App::HPGL2Cadsoft object. Supported
    parameters are listed below

    input_file
        This is a required parameter that contains the name of the HPGL file
        that needs to be converted to a Cadsoft Eagle script.

        = item output_file

        This is a required parameter that contains the name of the output
        script

    scaling_factor
        The scaling factor to apply on the HPGL script to convert the script
        to millimeters. Use this factor to make the Cadsoft Eagle output
        smaller or larger. To help you in selecting the correct scaling
        factor this module will report the bounding box of the output.

  "run()"
    This function runs all steps required to read and scale the HPGL input
    file and to write the output to the Cadsoft Eagle script.

  BUILD
    Helper function to run custome code after the object has been created by
    Moose.

AUTHOR
    Lieven Hollevoet <hollie@cpan.org>

COPYRIGHT AND LICENSE
    This software is copyright (c) 2014 by Lieven Hollevoet.

    This is free software; you can redistribute it and/or modify it under
    the same terms as the Perl 5 programming language system itself.

