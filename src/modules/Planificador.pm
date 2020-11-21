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
# sub seleccionar() {
#     my ( $self ) = @_;
#     return $self->_listos.shift();
# }

# # Agregar proceso nuevo a la cola de nuevos procesos
# sub planificar_nuevo() {
#     my ( $self ) = @_;
#     my proceso_nuevo = shift;
#     # push($self->_nuevos, proceso_nuevo);
# }

# # Actualizar el ciclo de CPU actual
# sub actualizar_ciclos() {
#     my ( $self ) = @_;
#     my ciclo_cpu = shift;
#     # $self->_ciclos = ciclo_cpu;
# }

1;
