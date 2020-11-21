#!/usr/bin/perl

package Proceso;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = {
        _llegada => shift,
        _cpu_duracion => shift,
        _proceso_id => shift
    };

    bless $self, $class;

    return $self
}

sub llegada() {
    my ( $self ) = @_;
    return $self->{_llegada};
}

sub cpu_duracion() {
    my ( $self ) = @_;
    return $self->{_cpu_duracion};
}

sub proceso_id() {
    my ( $self ) = @_;

    return $self->{_proceso_id};
}

1;
