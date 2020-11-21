#!/usr/bin/perl

package Proceso;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = {
        _inicio => shift,
        _fin => shift,
    };

    bless $self, $class;

    return $self
}

sub inicio_T() {
    my ( $self ) = @_;
    return $self->_inicio;
}

sub fin_T() {
    my ( $self ) = @_;
    return $self->fin;
}

1;
