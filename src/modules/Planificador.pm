#!/usr/bin/perl

package Planificador;

# use strict;
use warnings;

=pod
Planificador esta a cargo de tomar proceso de la cola de _nuevos procesos y planificar su orden de ejecucion en la cola de _listos
=cut
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

=pod
Planificar el siguiente proceso mediante FIFO
Verificar que proceso de la cola _nuevos deben pasar a la cola de listos
=cut
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

=pod
Actualizar el Ciclo actual al planificador
=cut
sub actualizar_ciclos() {
    my ( $self, $ciclos ) = @_;
    $self->{_ciclos} = $ciclos;
}

1;
