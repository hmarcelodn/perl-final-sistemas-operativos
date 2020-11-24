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

    if ( $self->{_listos}->contar() > 0 && $self->{_cpu}->estado() eq "LIBRE" ) {
        my $proceso_ejecucion = $self->{_listos}->desencolar();

        print $self->{_listos}->contar()." PROCESOS PARA DESPACHAR ESPERANDO \n";
        print "DESPACHA PROCESO ".$proceso_ejecucion->proceso_id()." \n";

        $proceso_ejecucion->cambiar_a_ejecutando();
        $self->{_cpu}->asignar($proceso_ejecucion);
        # $self->{_ejecutando}->encolar($proceso_ejecucion);
    } elsif ( $self->{_listos}->contar() > 0 && $self->{_cpu}->estado() eq "OCUPADO" ) {
        print $self->{_listos}->contar()." PROCESOS PARA DESPACHAR ESPERANDO \n";
    } else {
        print "NINGUN PROCESO PARA DESPACHAR \n"
    }
}

1;
