#!/usr/bin/perl

package Os;

use strict;
use warnings;

use threads::shared;

sub new {
    my $class = shift;

    my $self = {
        _listos                      => shift,
        _proceso                     => undef,
        _cola_procesadores           => shift,
        _cola_ejecucion              => shift,
    };

    bless $self, $class;

    return $self;
}

sub asignar_proceso() {
    my ( $self, $proceso ) = @_;

    $self->{_proceso} = $proceso;
}

sub semWait() {
    my ( $self, $semaforo ) = @_;

    $semaforo->down();

    if ( $semaforo->contar() < 0 ) {
        # print "\n DURMIENDO PROCESO! \n";

        # Libero el procesador del proceso bloqueado
        my $cpu = $self->{_cola_procesadores}->peek( 0 );

        # Primero duermo al CPU y luego duermo al proceso (queda bloqueado)
        $cpu->cambiar_libre();
        $self->{_cola_ejecucion}->dequeue_nb();
        $self->{_proceso}->sumar_tiempo_servicio();
        $semaforo->dormir_proceso( $self->{_proceso} );
    }
}


sub semSignal() {
    my ( $self, $semaforo ) = @_;

    $semaforo->up();

    if ( $semaforo->contar() <= 0 ) {
        # Desencolar la cola de ocupados del semaforo
        my $proceso_listo = $semaforo->despertar_proceso();
        $proceso_listo->cambiar_a_listo();
        $self->{_listos}->enqueue( $proceso_listo );
    }
}

1;
