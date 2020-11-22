#!/usr/bin/perl

package Planificador;

# use strict;
use warnings;

sub new {
    my $class = shift;
    my $self = {
        _nuevos => shift,
        _listos => shift,
        _ciclos => shift,
        _cpu => shift,
    };

    bless $self, $class;

    return $self;
}

# Seleccionar siguiente proceso
sub planificar() {
    my ( $self ) = @_;

    my @nuevos = ();

    # Planificar procesos nuevos y moverlos a listos si cumple el tiempo de llegada
    while ( $self->{_nuevos}->contar() > 0 ) {
        my $proceso_nuevo = $self->{_nuevos}->desencolar();
        my $ciclo_actual = $self->{_ciclos};
        my $proceso_nuevo_llegada = $proceso_nuevo->llegada();
        if ( $ciclo_actual >= $proceso_nuevo->llegada() ) {
            $self->{_listos}->encolar($proceso_nuevo);
        } else {
            push( @nuevos, $proceso_nuevo );
        }
    }

    # Encolar los procesos nuevos que no pueden entrar a la cola de listos aun
    foreach ( @nuevos ) {
        $self->{_nuevos}->encolar( $_ );
    }

    return $self->{_ciclos};
}

# # Actualizar el ciclo de CPU actual
sub actualizar_ciclos() {
    my ( $self, $ciclos ) = @_;
    $self->{_ciclos} = $ciclos;
}

1;
