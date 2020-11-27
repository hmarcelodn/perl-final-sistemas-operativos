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

# Ejecutar ciclo
sub ejecutar() {
    my ( $self, $dba ) = @_;

    if ( ref $self->{_proceso} && $self->{_proceso}->tiempo_servicio() > 0) {
        $self->cambiar_ocupado();
        $self->{_proceso}->{_tiempo_servicio} = $self->{_proceso}->tiempo_servicio() - 1;
        $self->{_proceso}->ejecutar($dba);

        if ( $self->{_proceso}->tiempo_servicio() == 0 ) {
            $self->{_proceso}->cambiar_a_finalizado();
            $self->cambiar_libre();
            $self->{_proceso} = undef;
        }
    }
}

1;
