#!/usr/bin/perl

package Db;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = {
        _nombre_db => shift,
        _cantidad_disponible => shift,
    };

    bless $self, $class;

    return $self
}

sub set_nombre_db() {
    my ($self, $value) = @_;
    $self->{_nombre_db} = $value;
}

sub get_nombre_db() {
    my ($self) = @_;
    return $self->{_nombre_db};
}

sub set_cantidad_disponible() {
    my ($self, $value) = @_;
    $self->{_cantidad_disponible} = $value;
}

sub get_cantidad_disponible() {
    my ($self) = @_;
    return $self->{_cantidad_disponible};
}

sub leer_db() {
    my ($self, $value) = @_;
    $self->{_cantidad_disponible} -= $value;
}

sub grabar_db() {
    my ($self, $value) = @_;
    $self->{_cantidad_disponible} += $value;
}

sub print_disponible() {
    my ($self) = @_;
    print "Disponible en DB: " . $self->{_cantidad_disponible};
}

1;
