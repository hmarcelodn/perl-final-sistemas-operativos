#!/usr/bin/perl

package Proceso;

use strict;
use warnings;

=pod
Representa una abstraccion del proceso
Es una generalidad del proceso Lector/Escritor
=cut
sub new {
    my $class = shift;

    my $self = {
        _llegada         => shift,
        _tiempo_servicio => shift,
        _proceso_id      => shift,
        _estado          => shift,
        _cantidad        => shift,
        _procesos_finalizados => shift,
        _ciclo_siguiente_semaforo => shift,
        _ciclo_siguiente_sumar_semaforo => shift,
    };

    bless $self, $class;

    return $self
}

=pod
Devolver el T de llegada del proceso (en que ciclo deberia entrar a la cola de listos)
=cut
sub llegada() {
    my ( $self ) = @_;
    return $self->{_llegada};
}

=pod
Devolver el tiempo de servicio (rafagas de CPU necesarias por el proceso)
=cut
sub tiempo_servicio() {
    my ( $self ) = @_;
    return $self->{_tiempo_servicio};
}

=pod
Devolver el ID de proceso
=cut
sub proceso_id() {
    my ( $self ) = @_;

    return $self->{_proceso_id};
}

=pod
Modifica el estado interno del servicio a EJECUTANDO
=cut
sub cambiar_a_ejecutando() {
    my ( $self ) = @_;
    $self->{_estado} = "EJECUTANDO";
}

=pod
Modifica el estado interno del servicio a LISTO
=cut
sub cambiar_a_listo() {
    my ( $self ) = @_;
    $self->{_estado} = "LISTO";
}

=pod
Modifica el estado interno del servicio a FINALIZADO
=cut
sub cambiar_a_finalizado() {
    my ( $self ) = @_;
    $self->{_estado} = "FINALIZADO";

    $self->{_ciclo_siguiente_sumar_semaforo}->up();
}

=pod
Modifica el estado interno del servicio a BLOQUEADO
=cut
sub cambiar_a_bloqueado() {
    my ( $self ) = @_;
    $self->{_estado} = "BLOQUEADO";

    # Bloqueo el hilo
    print " \n Antes de dormir, estado: $self->{_estado} \n";
    while ($self->{_estado} == "BLOQUEADO") {
        print "\n Me voy a dormir: $self->{_proceso_id} \n";
        sleep 1;
    }
}

=pod
Devuelve la cantidad a leer / escribir
=cut

sub get_cantidad() {
    my ( $self ) = @_;
    return $self ->{_cantidad};
}

1;
