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
        _cola_bloqueados_lectores               => shift,
        _cola_bloqueados_escritores             => shift,
    };

    bless $self, $class;

    return $self;
}

sub asignar_proceso() {
    my ( $self, $proceso ) = @_;

    $self->{_proceso} = $proceso;
}

sub bloquear_proceso_escritor() {
    my ( $self, $proceso ) = @_;

    my $cpu = $self->{_cola_procesadores}->peek( 0 );

    # Primero duermo al CPU y luego duermo al proceso (queda bloqueado)
    $cpu->cambiar_libre();
    $self->{_cola_ejecucion}->dequeue_nb();
    $proceso->sumar_tiempo_servicio();
    $proceso->restar_ejecuciones();
    $proceso->cambiar_a_bloqueado();
    $self->{_cola_bloqueados_escritores}->enqueue( $proceso );
}

sub bloquear_proceso_lector() {
    my ( $self, $proceso ) = @_;

    my $cpu = $self->{_cola_procesadores}->peek( 0 );

    # Primero duermo al CPU y luego duermo al proceso (queda bloqueado)
    $cpu->cambiar_libre();
    $self->{_cola_ejecucion}->dequeue_nb();
    $proceso->sumar_tiempo_servicio();
    $proceso->cambiar_a_bloqueado();
    $self->{_cola_bloqueados_lectores}->enqueue( $proceso );
}

1;
