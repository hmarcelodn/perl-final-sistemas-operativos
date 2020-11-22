#!/usr/bin/perl

package Cpu;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $self = {
        _proceso => undef,
        _estado => "LIBRE"
    };

    bless $self, $class;

    return $self
}

sub asignar() {
    my ( $self, $proceso ) = @_;
    $self->{_proceso}=$proceso;
}

sub estado() {
    my ( $self, $proceso ) = @_;
    return $self->{_estado};
}

sub cambiar_libre() {
    my ( $self, $proceso ) = @_;
    $self->{_estado} = "LIBRE";
}

sub cambiar_ocupado() {
    my ( $self, $proceso ) = @_;
    $self->{_estado} = "OCUPADO";
}

sub ejecutar() {
    my ( $self ) = @_;

    if ( ref $self->{_proceso} && $self->{_proceso}->tiempo_servicio() > 0) {
        $self->cambiar_ocupado();
        $self->{_proceso}->{_tiempo_servicio} = $self->{_proceso}->tiempo_servicio() - 1;
        $self->{_proceso}->ejecutar();

        if ( $self->{_proceso}->tiempo_servicio() == 0 ) {
            $self->{_proceso}->cambiar_a_finalizado();
            $self->cambiar_libre();
        }
    } else {
        print "CPU OCIOSO \n";
    }
}

1;
