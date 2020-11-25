#!/usr/bin/perl

package Lector;

use strict;
use warnings;

use Db;

=pod
Representa un proceso Lector generalizado a partir del paquete Proceso
=cut
our @ISA = qw(Proceso);    # inherits from Proceso

sub new {
    my $class = shift;
    my $self = $class->SUPER::new( $_[1], $_[2], $_[3], $_[4], $_[5] );

    $self->{_db}  = undef;

    bless($self, $class);
    return $self;

}

sub leer_db() {
    my( $self ) = @_;
    Db->leer_db($self->get_cantidad());
}

sub log_proceso() {
    my( $self ) = @_;
    printf "\nProceso Lector $self->{$_[3]} arrivado en $self->{_llegada} \n";
}

1;
