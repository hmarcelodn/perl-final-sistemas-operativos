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
        _ciclo_siguiente_semaforo => shift,
        _quantum         => 0,
        _ejecuciones     => 0,
        _os              => shift,
        _contador_lectores => shift,
        _cola_lectores     => shift,
        _cola_escritores   => shift,
    };


    bless $self, $class;

    return $self
}

=pod
Sumar las ejecuciones del proceso
=cut
sub sumar_ejecuciones() {
    my ( $self, $quantum ) = @_;

    $self->{_ejecuciones} = $self->{_ejecuciones} + 1;
}

=pod
Restar ejecuciones del proceso
=cut
sub restar_ejecuciones() {
    my ( $self, $quantum ) = @_;

    $self->{_ejecuciones} = $self->{_ejecuciones} - 1;
}

=pod
Retornar las ejecuciones actuales
=cut
sub contar_ejecuciones() {
    my ( $self, $quantum ) = @_;

    return $self->{_ejecuciones};
}

=pod
Asignar tiempo de quantum al proceso (renovar)
=cut
sub asignar_quantum() {
    my ( $self, $quantum ) = @_;

    $self->{_quantum} = $quantum;
}

=pod
Retornar tiempo de quantum asociado al proceso
=cut
sub contar_quantums() {
    my ( $self, $quantum ) = @_;

    return $self->{_quantum};
}

sub descontar_quantum() {
    my ( $self ) = @_;

    $self->{_quantum} = $self->{_quantum} - 1;
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
}

=pod
Modifica el estado interno del servicio a BLOQUEADO
=cut
sub cambiar_a_bloqueado() {
    my ( $self ) = @_;
    $self->{_estado} = "BLOQUEADO";
}

=pod
Devuelve la cantidad a leer / escribir
=cut
sub get_cantidad() {
    my ( $self ) = @_;
    return $self ->{_cantidad};
}

=pod
Sumar tiempo de servicio
=cut
sub sumar_tiempo_servicio() {
    my ( $self ) = @_;

    $self->{_tiempo_servicio} = $self->{_tiempo_servicio} + 1;
}


1;
