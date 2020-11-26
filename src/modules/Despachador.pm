#!/usr/bin/perl

package Despachador;

use strict;
use warnings;

=pod
El despachador se encarga de tomar procesos de la cola de _listos (ordenado por el planificador) y asignarles tiempo de CPU
=cut
sub new {
    my $class = shift;
    my $self = {
        _nuevos => shift,
        _listos => shift,
        _ejecutando => shift,
        _salida => shift,
        _cpu => shift,
    };

    bless $self, $class;

    return $self;
}

=pod
Tomar proceso de la cola de listos, si el CPU se encuentra LIBRE y asignarle/despachar el siguiente proceso de la cola de _listos
=cut
sub despachar() {
    my ( $self ) = @_;

    if ( $self->{_listos}->pending() > 0 && $self->{_cpu}->estado() eq "LIBRE" ) {
        my $proceso_ejecucion = $self->{_listos}->dequeue_nb();

        $proceso_ejecucion->cambiar_a_ejecutando();
        $self->{_cpu}->asignar($proceso_ejecucion);
    }
}

1;
