#!/usr/bin/perl

package Despachador;

use strict;
use warnings;

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

# Sacar el proximo proceso listo de la cola de listos
# Poner en la cola de procesos en ejecucion al proceso siguiente
sub despachar() {
    my ( $self ) = @_;

    if ( $self->{_listos}->contar() > 0 && $self->{_cpu}->estado() eq "LIBRE" ) {
        my $proceso_ejecucion = $self->{_listos}->desencolar();

        print "DESPACHA PROCESO ".$proceso_ejecucion->proceso_id()." \n";

        $proceso_ejecucion->cambiar_a_ejecutando();
        $self->{_cpu}->asignar($proceso_ejecucion);
        #$self->{_ejecutando}->encolar($proceso_ejecucion);
    } elsif ( $self->{_listos}->contar() > 0 && $self->{_cpu}->estado() eq "OCUPADO" ) {
        print $self->{_listos}->contar()." PROCESOS PARA DESPACHAR ESPERANDO \n";
    } else {
        print "NINGUN PROCESO PARA DESPACHAR \n"
    }
}

1;
