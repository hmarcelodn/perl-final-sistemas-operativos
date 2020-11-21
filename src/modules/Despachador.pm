#!/usr/bin/perl

package Despachador;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $self = {
        _nuevos => shift,
        _listos => shift,
        _ejecutando => shift,
        _salida => shift,
    };

    bless $self, $class;

    return $self;
}

sub despachar() {
    
}

1;
