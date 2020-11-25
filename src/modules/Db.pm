#!/usr/bin/perl

package Db;

use strict;
use warnings;

# sub new {
#     my $class = shift;
#
#     my $self = {
#         _nombre_db => shift,
#         _cantidad_disponible => shift,
#     };
#
#     bless $self, $class;
#
#     return $self
# }

my $_nombre_db = undef;
my $_cantidad_disponible = undef;


sub set_nombre_db() {
    my ($value) = @_;
    $_nombre_db = $value;
}

sub get_nombre_db() {
    return $_nombre_db;
}

sub set_cantidad_disponible() {
    my ($value) = @_;
    $_cantidad_disponible = $value;
}

sub get_cantidad_disponible() {
    return $_cantidad_disponible;
}

# Metodo estatico para leer y bajar la cantidad de valor de la DB
sub leer_db() {
    my ($value) = @_;
    $_cantidad_disponible -= $value;
}

# Metodo estatico para leer y aumentar la cantidad de valor de la DB
sub grabar_db() {
    my ($value) = @_;
    $_cantidad_disponible += $value;
}

1;
