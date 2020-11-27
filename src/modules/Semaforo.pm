#!/usr/bin/perl

package Semaforo;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = {
        _name => shift,
        _count => shift,
        _items => [],
        _proceso => undef,
    };

    bless $self, $class;

    return $self
}

sub down() {
    my ( $self, $proceso ) = @_;

    if ( $self->{_count} < 1 ) {
        @push ( $self->{_items}, $proceso )
    } else {
        $self->{_count} = $self->{_count} + 1;
    }
}

sub up() {
    my ( $self ) = @_;

    $self->{_count} = $self->{_count} - 1;
}

sub contar() {
    my ( $self ) = @_;

    return scalar @{$self->{_items}};
}

sub despertar_proceso() {
    my ( $self, $proceso ) = @_;

    if ( $self->{_count} == 1 ) {
        return shift(@{$self->{_items}});
    }
}

