#!/usr/bin/perl

package Os;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = {
        _listos        => shift,
        _proceso       => undef,
    };

    bless $self, $class;

    return $self;
}

sub asignar_proceso() {
    my ( $self, $proceso ) = @_;
    $self->{_proceso} = $proceso;

    # my $pepe2 = $proceso->proceso_id();

    # print "\n Existe PROCESO en ASIGNAR??: $pepe2 \n";
    # my $pepe = $self->{_proceso}->proceso_id();
    # print "\n Existe PROCESO GRABADO??: $pepe \n";
}

sub semWait() {
    my ( $self, $semaforo ) = @_;
    my $pepe5= $semaforo->contar();
    # print " \n Semaforo contar en OS semWait: $pepe5 \n";

    $semaforo->down();
    if ( $pepe5 < 0 ) {
        $semaforo->dormir_proceso( $self->{_proceso} );
    }
}


sub semSignal() {
    my ( $self, $semaforo ) = @_;

    $semaforo->up();
    my $cant = $semaforo->contar();

    if ( $cant < 0 ) {
        my $proceso_listo = $semaforo->despertar_proceso();
        $proceso_listo->cambiar_a_listo();
        $self->{_listos}->enqueue( $proceso_listo );
    }
}

1;
