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
        _db              => shift,
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
}

=pod
Ejecuta comportamiento de proceso
=cut
sub ejecutar() {
    my ( $self ) = @_;

    print "CPU PROCESO $self->{_proceso_id} ($self->{_estado}) - SERVICIO RESTANTE $self->{_tiempo_servicio} 🚀  \n";
}

=pod
Devuelve la cantidad a leer / escribir
=cut

sub get_cantidad() {
    my ( $self ) = @_;
    return $self ->{_cantidad};
}

=pod
Devuelve la cantidad a leer / escribir
=cut

sub get_db() {
    my ( $self ) = @_;
    return $self ->{_db};
}

1;
