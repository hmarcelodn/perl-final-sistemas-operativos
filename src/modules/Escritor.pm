#!/usr/bin/perl

package Escritor;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $self = {};

    bless $self, $class;

    return $self
}

1;
