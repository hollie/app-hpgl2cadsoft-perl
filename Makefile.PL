
# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.019.
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "module to convert a HPGL file into a Cadsoft Eagle script",
  "AUTHOR" => "Lieven Hollevoet <hollie\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "App-HPGL2Cadsoft",
  "EXE_FILES" => [
    "bin/hpgl2cadsoft.pl"
  ],
  "LICENSE" => "perl",
  "NAME" => "App::HPGL2Cadsoft",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Getopt::Long" => 0,
    "Grid::Coord" => 0,
    "IO::File" => 0,
    "Modern::Perl" => 0,
    "Moose" => 0,
    "Pod::Usage" => 0,
    "namespace::autoclean" => 0,
    "strict" => 0
  },
  "TEST_REQUIRES" => {
    "Test::Exception" => 0,
    "Test::More" => 0,
    "Test::Warn" => 0
  },
  "VERSION" => "0.01",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Carp" => 0,
  "Getopt::Long" => 0,
  "Grid::Coord" => 0,
  "IO::File" => 0,
  "Modern::Perl" => 0,
  "Moose" => 0,
  "Pod::Usage" => 0,
  "Test::Exception" => 0,
  "Test::More" => 0,
  "Test::Warn" => 0,
  "namespace::autoclean" => 0,
  "strict" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



