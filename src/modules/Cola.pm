#!/usr/bin/perl

package Cola;

use strict;
use warnings;

=pod
Estructura de datos de Cola
=cut
sub new {
    my $class = shift;

    my $self = {
        _items => [],
    };

    bless $self, $class;

    return $self
}

=pod
Obtener el numero de items en la cola
=cut
sub contar() {
    my ( $self ) = @_;
    return scalar @{$self->{_items}};
}

=pod
Encolar un nuevo item
=cut
sub encolar() {
    my ( $self, $item ) = @_;
    push(@{$self->{_items}}, $item);
}

=pod
Desencolar un nuevo item
=cut
sub desencolar() {
    my ( $self ) = @_;
    return shift(@{$self->{_items}});
}

1;
