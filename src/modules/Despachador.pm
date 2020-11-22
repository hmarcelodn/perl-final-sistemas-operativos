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
    };

    bless $self, $class;

    return $self;
}

# Sacar el proximo proceso listo de la cola de listos
# Poner en la cola de procesos en ejecucion al proceso siguiente
sub despachar() {
    my ( $self ) = @_;

    if ( $self->{_listos}->contar() > 0 ) {
        my $proceso_ejecucion = $self->{_listos}->desencolar();
        $self->{_ejecutando}->encolar($proceso_ejecucion);
        print "DESPACHA PROCESO ".$proceso_ejecucion->proceso_id()." 🚀 \n";
    } else {
        print "NINGUN PROCESO PARA DESPACHAR \n"
    }
}

1;
