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
    my ( $self ) = @_;

    $self->{_count} = $self->{_count} - 1;
    my $pepe3 = $self->{_count};
    my $pepe4 = $self->{_name};
    # print " \n Hago un up: $pepe3 $pepe4 \n";
}

sub up() {
    my ( $self ) = @_;

    $self->{_count} = $self->{_count} + 1;
    my $pepe3 = $self->{_count};
    my $pepe4 = $self->{_name};
    # print " \n Hago un up: $pepe3 $pepe4 \n";
}

sub contar() {
    my ( $self ) = @_;

    return scalar @{$self->{_items}};
}

sub dormir_proceso() {
    my ( $self, $proceso ) = @_;
    # print " \n Dormir Proceso: $proceso \n";
    $proceso->cambiar_a_bloqueado();
    push ( $self->{_items}, $proceso );
}

sub despertar_proceso() {
    my ( $self ) = @_;
    # print " \n Cantidad:   @{$self->{_items}} \n";
    if ( $self->{_count} > 0 ) {
        return shift(@{$self->{_items}});
    }
}

1;
