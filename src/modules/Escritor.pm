#!/usr/bin/perl

package Escritor;

use strict;
use warnings;

=pod
Representa un proceso Escritor generalizado a partir del paquete Proceso
=cut
our @ISA = qw(Proceso);    # inherits from Proceso

sub new {
    my ($class) = @_;
    my $self = $class->SUPER::new( $_[1], $_[2], $_[3], $_[4], $_[5] );
    print $self->get_cantidad() . "En constructor";

    bless $self, $class;
    return $self

}

=pod
Ejecuta comportamiento de proceso
=cut
sub ejecutar() {
    my ( $self, $dba ) = @_;
    $dba->{_cantidad_disponible} += $self->{_cantidad};
    print "CPU PROCESO ESCRITOR $self->{_proceso_id} ($self->{_estado}) - SERVICIO RESTANTE $self->{_tiempo_servicio} 🚀  \n";
}

sub log_proceso() {
    my( $self ) = @_;
    printf "\nProceso Lector $self->{$_[3]} arrivado en $self->{_llegada} \n";
}


1;
