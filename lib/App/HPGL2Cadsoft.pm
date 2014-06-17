use strict
  ; # Keep Perl::Critic happy, althoug this is covered my the Modern::Perl too...

package App::HPGL2Cadsoft;

use Modern::Perl;
use Moose;
use IO::File;
use Grid::Coord;
use namespace::autoclean;
use Carp;

use Carp qw/croak carp/;

has scaling_factor => (
    is      => 'ro',
    isa     => 'Num',
    default => 342.3151,
);

has input_file => (
    is       => 'ro',
    isa      => 'Str',
    required => '1',
);

has output_file => (
    is  => 'ro',
    isa => 'Str',
);

has '_bbox' => (
    is       => 'rw',
    isa      => 'Grid::Coord',
    init_arg => undef,
);

has '_hpgl' => (
    is       => 'rw',
    isa      => 'Str',
    init_arg => undef,
);

has '_hpgl_lines' => (
    is       => 'rw',
);

# Actions that need to be run after the constructor
sub BUILD {
    my $self = shift;

    # Add stuff here

    my $hpgl;

    my $fh = IO::File->new( "< " . $self->input_file );

    if ( defined $fh ) {

        # Slurp the file into the variable
        while (<$fh>) {
            $hpgl .= $_;
        }
    }
    else {
        die "Could not open inputfile for reading";
    }

    $fh->close();
    $self->_hpgl($hpgl);

}

sub _parse_hpgl {
    my $self = shift();

    my @lines;
    my $zero_length_stubs = 0;

    my @commands = split( ";", $self->_hpgl() );

    my $command;
    my ( $pos_start, $pos_end );

    foreach $command (@commands) {

        if ( $command =~ /PU(\d+),(\d+)/ ) {
            $pos_start = Grid::Coord->new( $2, $1 );
            next;
        }

        if ( $command =~ /PD(\d+),(\d+)/ ) {
            $pos_end = Grid::Coord->new( $2, $1 );

            if ( !$pos_start->equals($pos_end) ) {

                # Store the position as a line
                push( @lines, [ $pos_start, $pos_end ] );

# And update the last location to ensure we create a valid line when the next command is PD again
                $pos_start = $pos_end;
            }
            else {
                $zero_length_stubs++;
            }
            next;
        }
        if ( $command =~ /IN/ ) {
            say "Init sequence found";
            next;
        }

        if ( $command =~ /SP(\d+)/ ) {
            say "Selected pen $1";
            next;
        }

        carp "Encountered command that was not parsed: $command\n";
    }

    my $line_count = scalar(@lines);

    $self->_hpgl_lines(\@lines);
    return ( $line_count, $zero_length_stubs);

}

# Applies the scaling factor to the lines in the data array
sub _scale {
    
    my $self = shift();
        
    # Scale the lines
    my @lines_scaled;
    
    foreach my $line (@{$self->_hpgl_lines()}) {
        my $start_scaled = Grid::Coord->new( $line->[0]->min_y() / $self->scaling_factor(),
            $line->[0]->min_x() / $self->scaling_factor() );
        my $stop_scaled = Grid::Coord->new( $line->[1]->min_y() / $self->scaling_factor(),
            $line->[1]->min_x() / $self->scaling_factor() );

        push( @lines_scaled, [ $start_scaled, $stop_scaled ] );
    }  
    
    $self->_hpgl_lines(\@lines_scaled);
}

sub run {
    my $self = shift();
    
    my ($lines, $zero_stubs)= $self->_parse_hpgl();
    say "Found $lines valid segments in HPGL file";
    say "Skipped $zero_stubs segments with zero length";
    
    $self->_scale();
    $self->_calculate_bbox();
    
    # Report bounding box dimensions, maybe the user wants to change the scaling factor
       say "Object bounding box stretches from (x,y) to (x,y) in millimeter:";
    say "   ("
      . sprintf( '%.3f', $self->_bbox->min_x() ) . " "
      . sprintf( '%.3f', $self->_bbox->min_y() ) . ") ("
      . sprintf( '%.3f', $self->_bbox->max_x() ) . " "
      . sprintf( '%.3f', $self->_bbox->max_y() ) . ")";

    say
"Total dimensions in x and y directions with scaling factor " . $self->scaling_factor() . " in mm are:";
    say "   ("
      . sprintf( '%.3f', $self->_bbox->max_x() - $self->_bbox->min_x() ) . " "
      . sprintf( '%.3f', $self->_bbox->max_y() - $self->_bbox->min_y() ) . ")";
      

    # Generate the script
    say "-- script follows --";

    say "grid mm";
    say "grid 1";
    say "set wire_bend 2";
    say "change width 0";



    map {
            say "wire ("
          . sprintf( '%.3f', $_->[0]->min_x() ) . " "
          . sprintf( '%.3f', $_->[0]->min_y() ) . ") ("
          . sprintf( '%.3f', $_->[1]->min_x() ) . " "
          . sprintf( '%.3f', $_->[1]->min_y() ) . ")"
    } @{$self->_hpgl_lines()};

    say "-- end of script --";

 

    say "Done!";
}

sub _calculate_bbox {
    my $self = shift();

    # Init min and max values to the first point in the dataset
    my $l = $self->_hpgl_lines()->[0]->[0];

# Create bounding box with min and max values to be equal to the first point in the dataset
    $self->_bbox(
      Grid::Coord->new( $l->min_y(), $l->min_x() => $l->max_y(), $l->max_x() )
    );

    foreach my $line (@{$self->_hpgl_lines()}) {
        my $start = $line->[0];
        my $stop  = $line->[1];

        if ( !$self->_bbox->contains($start) ) {
            $self->_grow_bbox( $start );
        }

        if ( !$self->_bbox->contains($stop) ) {
            $self->_grow_bbox( $stop );
        }
    }

}

sub _grow_bbox {
    my $self  = shift();
    my $point = shift();

    my $bbox = \$self->_bbox;
    
    $$bbox->min_y( $point->min_y() ) if ( $point->min_y() < $$bbox->min_y() );
    $$bbox->min_x( $point->min_x() ) if ( $point->min_x() < $$bbox->min_x() );
    $$bbox->max_y( $point->max_y() ) if ( $point->max_y() > $$bbox->max_y() );
    $$bbox->max_x( $point->max_x() ) if ( $point->max_x() > $$bbox->max_x() );

    # Safety check
    warn "Bbox not updated as expected" if ( !$$bbox->contains($point) );

}

# Speed up the Moose object construction
__PACKAGE__->meta->make_immutable;
no Moose;
1;

# ABSTRACT: module to convert a HPGL file into a Cadsoft Eagle script

=head1 SYNOPSIS

my $object = App::HPGL2Cadsoft->new(parameter => 'text.txt');

=head1 DESCRIPTION

This module enables conversion of a HPGL graphical file into a script that can be imported
in the Cadsoft Eagle printed circuit board design tool.

=head1 METHODS

=head2 C<new(%parameters)>

This constructor returns a new App::HPGL2Cadsoft object. Supported parameters are listed below

=over

=item parameters

Describe

=back

=head2 C<calculate_bbox()>

Calculate the bounding box that encloses the entire drawing

=head2 BUILD

Helper function to run custome code after the object has been created by Moose.

=cut

