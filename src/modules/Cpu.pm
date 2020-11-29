#!/usr/bin/perl

package Cpu;

use strict;
use warnings;

=pod
Representa una abstraccion del CPU. Su tarea es ejecutar proceso en cada ciclo de CPU.
=cut
sub new {
    my $class = shift;
    my $self = {
        _proceso => undef,
        _ciclo_siguiente_semaforo => shift,
        _estado => "LIBRE",
        _ciclos => 0,
    };

    bless $self, $class;

    return $self
}


sub proceso_asignado() {
    my ( $self ) = @_;

    if ( $self->{_proceso} ) {
        return $self->{_proceso}->proceso_id();
    }

    return "NINGUNO";
}

sub proceso_instancia() {
    my ( $self ) = @_;

    if ( $self->{_proceso} ) {
        return $self->{_proceso};
    }

    return undef;
}

# Utilizado por el dispatcher para asignar al CPU un nuevo proceso
sub asignar() {
    my ( $self, $proceso ) = @_;
    $self->{_proceso} = $proceso;
}

# Obtener estado de CPU
sub estado() {
    my ( $self, $proceso ) = @_;
    return $self->{_estado};
}

# Modificar el estado del CPU a LIBRE
sub cambiar_libre() {
    my ( $self, $proceso ) = @_;
    $self->{_estado} = "LIBRE";
}

# Modificar el estado del CPU a OCUPADO
sub cambiar_ocupado() {
    my ( $self, $proceso ) = @_;
    $self->{_estado} = "OCUPADO";
}

sub cambiar_ocioso() {
    my ( $self ) = @_;
    $self->{_ciclo_siguiente_semaforo}->up();
}

# Ejecutar ciclo
sub ejecutar() {
    my ( $self, $dba ) = @_;

    if ( ref $self->{_proceso} && $self->{_proceso}->tiempo_servicio() > 0) {
        $self->cambiar_ocupado();
        $self->{_proceso}->{_tiempo_servicio} = $self->{_proceso}->tiempo_servicio() - 1;
        $self->{_proceso}->descontar_quantum();
        $self->{_proceso}->ejecutar($dba);
        $self->{_proceso}->sumar_ejecuciones();

        if ( $self->{_proceso}->tiempo_servicio() == 0 ) {
            print "\n H1 \n";
            $self->{_proceso}->cambiar_a_finalizado();
            $self->cambiar_libre();
            $self->{_proceso} = undef;
        } elsif ( $self->{_proceso}->contar_quantums() == 0 ) {
            print "\n H2 \n";
            $self->{_proceso}->cambiar_a_listo();
            $self->cambiar_libre();
            $self->{_proceso} = undef;
        } else {
            print "\n H3 \n";
        }

        $self->{_ciclo_siguiente_semaforo}->up();
    }
}

1;
