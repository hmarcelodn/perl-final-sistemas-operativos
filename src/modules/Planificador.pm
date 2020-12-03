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
        _ejecutando => shift,
        _escritores_bloqueados => shift,
        _escritores => shift,
        _lectores => shift,
        _lectores_bloqueados => shift,
    };

    bless $self, $class;

    return $self;
}

=pod
Planificar cola de bloqueados
=cut
sub planificar_mediano_plazo() {
    my ( $self ) = @_;

    # Planifico escritores bloqueados, si no hay escritores ni lectores y existen escritores bloqueados
    if ( $self->{_escritores}->pending() == 0 && $self->{_lectores}->pending() == 0 && $self->{_escritores_bloqueados}->pending() > 0 ) {
        while($self->{_escritores_bloqueados}->pending() > 0) {
            my $proceso_bloqueado = $self->{_escritores_bloqueados}->dequeue_nb();
            $proceso_bloqueado->cambiar_a_listo();
            $self->{_listos}->enqueue( $proceso_bloqueado );
        }
    }

    # Planifico lectores bloqueados si no hay escritores y existen escritores bloqueados
    if ( $self->{_escritores}->pending() == 0 && $self->{_lectores_bloqueados}->pending() > 0 ) {
        while($self->{_lectores_bloqueados}->pending() > 0) {
            my $proceso_bloqueado = $self->{_lectores_bloqueados}->dequeue_nb();
            $proceso_bloqueado->cambiar_a_listo();
            $self->{_listos}->enqueue($proceso_bloqueado);
        }
    }
}

=pod
Planificar el siguiente proceso mediante RR=1
Verificar que proceso de la cola _nuevos deben pasar a la cola de listos
=cut
sub planificar() {
    my ( $self ) = @_;

    my @nuevos = ();

    # Planificar procesos nuevos y moverlos a listos si cumple el tiempo de llegada
    while ( $self->{_nuevos}->pending() > 0 ) {
        my $proceso_nuevo = $self->{_nuevos}->dequeue_nb();
        my $ciclo_actual = $self->{_ciclos};
        my $proceso_nuevo_llegada = $proceso_nuevo->llegada();
        if ( $ciclo_actual >= $proceso_nuevo->llegada() ) {
            $proceso_nuevo->asignar_quantum(2);
            $self->{_listos}->enqueue($proceso_nuevo);
        } else {
            push( @nuevos, $proceso_nuevo );
        }
    }

    # Encolar los procesos nuevos que no pueden entrar a la cola de listos aun
    foreach ( @nuevos ) {
        $self->{_nuevos}->enqueue( $_ );
    }

    # Acomodar la cola de listos por quantums

    if ( $self->{_ejecutando}->pending() > 0 ) {
        my $proceso_ejecutando = $self->{_ejecutando}->peek(0);

        # Si el proceso se quedo sin servicio sacarlo de la cola de ejecutando
        # Si el proceso se quedo sin quantums, renovarlos y mandar al final de la cola de listos
        if ( $proceso_ejecutando->tiempo_servicio() == 0 ) {
            $self->{_ejecutando}->dequeue_nb();
        } elsif ( $proceso_ejecutando->contar_quantums() == 0 ) {
            $proceso_ejecutando = $self->{_ejecutando}->dequeue_nb();
            $proceso_ejecutando->asignar_quantum(2);
            $self->{_listos}->enqueue( $proceso_ejecutando );
        }
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
