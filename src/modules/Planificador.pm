#!/usr/bin/perl

package Planificador;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $self = {
        _nuevos => shift,
        _listos => shift,
        _ciclos => shift,
    };

    bless $self, $class;

    return $self;
}

# Seleccionar siguiente proceso
sub planificar() {
    my ( $self ) = @_;

    return $self->{_ciclos};
}

# # Actualizar el ciclo de CPU actual
sub actualizar_ciclos() {
    my ( $self, $ciclos ) = @_;
    $self->{_ciclos} = $ciclos;
}

1;
