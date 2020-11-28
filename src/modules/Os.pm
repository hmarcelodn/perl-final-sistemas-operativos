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
}

sub semSignal() {
    my ( $self, $semaforo ) = @_;

    $semaforo->down();

    if ( $semaforo->contar() < 0 ) {
        $semaforo->dormir_proceso( $self->{_proceso} );
    }

}


sub semWait() {
    my ( $self, $semaforo ) = @_;

    $semaforo->up();

    if ( $semaforo->contar() <= 0 ) {
        my $proceso_listo = $semaforo->despertar_proceso();
        $proceso_listo->cambiar_a_listo();
        $self->{_listos}->enqueue( $proceso_listo );
    }
}

1;
