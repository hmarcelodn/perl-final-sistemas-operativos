#!/usr/bin/perl

package Proceso;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = {
        _llegada => shift,
        _cpu_ciclos_restantes => shift,
        _proceso_id => shift
    };

    bless $self, $class;

    return $self
}

sub llegada() {
    my ( $self ) = @_;
    return $self->{_llegada};
}

sub cpu_ciclos_restantes() {
    my ( $self ) = @_;
    return $self->{_cpu_ciclos_restantes};
}

sub proceso_id() {
    my ( $self ) = @_;

    return $self->{_proceso_id};
}

sub ejecutar() {
    my ( $self ) = @_;

    print "CPU EJECUTANDO $self->{_proceso_id}"
}

1;
