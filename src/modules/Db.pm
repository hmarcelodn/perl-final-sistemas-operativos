#!/usr/bin/perl

package Db;

use strict;
use warnings;

my $mutex_interrupcion :shared = 0;
my $mutex_grabar :shared = 0;
my $cantidad_recursos :shared = 0;
my $cant_lect :shared = 0;


sub new {
    my $class = shift;

    my $self = {
        _nombre_db => shift,
        _cantidad_disponible => shift,
    };

    $cantidad_recursos = $self->{_cantidad_disponible};

    bless $self, $class;
    return $self
}

sub set_nombre_db() {
    my ($self, $value) = @_;
    $self->{_nombre_db} = $value;
}

sub get_nombre_db() {
    my ($self) = @_;
    return $self->{_nombre_db};
}

sub set_cantidad_disponible() {
    my ($self, $value) = @_;
    $self->{_cantidad_disponible} = $value;
}

sub get_cantidad_disponible() {
    my ($self) = @_;
    return $self->{_cantidad_disponible};
}

sub leer_db() {
    my ($self, $value) = @_;
    if( $mutex_grabar == 0 && $self->{_cantidad_disponible} - $value > 0 && $mutex_interrupcion == 0) {
        $self->{_cantidad_disponible} -= $value;
        print "\n Lei $value \n";
    } else {
        print "\n No pude Leer \n";
    }
}

sub grabar_db() {
    my ($self, $value) = @_;
    if( $mutex_grabar == 0 && $cantidad_recursos > 0 ) {
        $self->{_cantidad_disponible} += $value;
        print "\n Grabe $value \n";

    } else {
        print "\n No pude grabar \n";
    }
}

sub bloquear_escritura() {
    $mutex_grabar = 1;
}

sub habilitar_escritura() {
    $mutex_grabar = 0;
    $mutex_interrupcion = 0;
}

sub down_recursos() {
    my ($cant) = @_;

    $cant_lect +=1;
    $cantidad_recursos -= $cant;
}

sub up_recursos() {
    my ($cant) = @_;

    $cant_lect -=1;
    $cantidad_recursos += $cant;
}

sub print_disponible() {
    my ($self) = @_;
    print " \n DISPONIBLE EN LA DB: " . $self->{_cantidad_disponible} . "\n";
}

1;
