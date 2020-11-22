#!/usr/bin/perl

package Proceso;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = {
        _llegada => shift,
        _tiempo_servicio => shift,
        _proceso_id => shift,
        _estado => shift,
    };

    bless $self, $class;

    return $self
}

sub llegada() {
    my ( $self ) = @_;
    return $self->{_llegada};
}

sub tiempo_servicio() {
    my ( $self ) = @_;
    return $self->{_tiempo_servicio};
}

sub proceso_id() {
    my ( $self ) = @_;

    return $self->{_proceso_id};
}

sub cambiar_a_ejecutando() {
    my ( $self ) = @_;
    $self->{_estado} = "EJECUTANDO";
}

sub cambiar_a_listo() {
    my ( $self ) = @_;
    $self->{_estado} = "LISTO";
}

sub cambiar_a_finalizado() {
    my ( $self ) = @_;
    $self->{_estado} = "FINALIZADO";
}

sub ejecutar() {
    my ( $self ) = @_;

    print "CPU PROCESO $self->{_proceso_id} ($self->{_estado}) - SERVICIO RESTANTE $self->{_tiempo_servicio} 🚀  \n";
}

1;
