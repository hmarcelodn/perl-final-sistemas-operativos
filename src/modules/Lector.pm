#!/usr/bin/perl

package Lector;

use strict;
use warnings;

=pod
Representa un proceso Lector generalizado a partir del paquete Proceso
=cut
@ISA = qw( Proceso );

sub new {
    my ($class) = @_;
    my $type = shift;
    my $self = $class -> new;

    return bless $self, $class, $type;

}

sub log_proceso() {
    my( $self ) = @_;
    printf "\nProceso Lector $self->{$_[3]} arrivado en $self->{$_[1]} \n";
}

1;
