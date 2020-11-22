#!/usr/bin/perl
use FindBin qw( $RealBin );
use lib "$RealBin/../src/modules";

use strict;
use warnings;

package Escritor;
use Proceso;
our @ISA = qw(Proceso);

sub new {
    my ($class) = @_;

    my $self = $class -> SUPER::new( $_[1], $_[2], $_[3] );

}

sub log_proceso() {
    my( $self ) = @_;
    printf "\nProceso Escritor $self->{$_[3]} arrivado en $self->{$_[1]} \n";
}

sub ejecutar_escritura() {

}
