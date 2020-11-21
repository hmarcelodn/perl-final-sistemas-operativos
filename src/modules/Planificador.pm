#!/usr/bin/perl

package Planificador;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $self = {};

    bless $self, $class;
    return $self;
}

sub inicio() {
    my ( $self ) = @_;
    return $self->{_inicio};
}

sub final() {
    my ( $self ) = @_;
    return $self->{_final};
}

1;
