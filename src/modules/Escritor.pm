#!/usr/bin/perl

package Escritor;

use strict;
use warnings;

=pod
Representa un proceso Escritor generalizado a partir del paquete Proceso
=cut
@ISA = qw( Proceso );

sub new {
    my ($class) = @_;

    my $self = $class -> SUPER::new( $_[1], $_[2], $_[3] );
    bless $self, $class;

    return $self

}

sub log_proceso() {
    my( $self ) = @_;
    printf "\nProceso Escritor $self->{$_[3]} arrivado en $self->{$_[1]} \n";
}


1;
