#!/usr/bin/perl

package Escritor;

use strict;
use warnings;

=pod
Representa un proceso Escritor generalizado a partir del paquete Proceso
=cut
sub new {
    my $class = shift;
    my $self = {};

    bless $self, $class;

    return $self
}

1;
