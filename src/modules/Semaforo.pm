#!/usr/bin/perl

package Semaforo;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = {
        _name => shift,
        _count => shift,
        _items => Thread::Queue->new(),
    };

    bless $self, $class;

    return $self
}

sub down() {
    my ( $self ) = @_;

    $self->{_count} = $self->{_count} - 1;
}

sub up() {
    my ( $self ) = @_;

    $self->{_count} = $self->{_count} + 1;
}

sub contar() {
    my ( $self ) = @_;

    return $self->{_count};
}

sub contar_items() {
    my ( $self ) = @_;

    return $self->{_items}->pending();
}

sub dormir_proceso() {
    my ( $self, $proceso ) = @_;

    # Encolar proceso bloqueado en el semaforo
    $self->{_items}->enqueue( $proceso );

    # Cambiar el proceso a bloqueado y bloquear el hilo
    $proceso->cambiar_a_bloqueado();
}

sub despertar_proceso() {
    my ( $self ) = @_;

    if ( $self->{_items}->pending() > 0 ) {
        return $self->{_items}->dequeue_nb();
    }
}

1;
