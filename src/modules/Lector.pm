#!/usr/bin/perl

package Lector;

use strict;
use warnings;

=pod
Representa un proceso Lector generalizado a partir del paquete Proceso
=cut
sub new {
    my $class = shift;
    my $self = {};

    bless $self, $class;

    return $self
}

1;
