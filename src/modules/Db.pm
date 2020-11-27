#!/usr/bin/perl

package Db;

use strict;
use warnings;
use Semaforo;

my $contador_lectores :shared = 0;
my $escribir_mutex = Semaforo->new('contador_lectores', 1);
my $sumar_mutex = Semaforo->new('sumar_mutex', 1);;

sub new {
    my $class = shift;

    my $self = {
        _nombre_db           => shift,
        _cantidad_disponible => shift,
        _escribir_mutex      => shift,
        _sumar_mutex         => shift,
    };

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

sub get_cantidad_disponible() {
    my ($self) = @_;
    return $self->{_cantidad_disponible};
}

sub leer_db() {
    my ($self, $proceso) = @_;
    $sumar_mutex->down($proceso);
    $contador_lectores = $contador_lectores + 1;

    if($contador_lectores == 1) {
        $escribir_mutex->down($proceso);
    }
    $sumar_mutex->up();

    print "\n Lei $proceso->{_cantidad} de $self->{_cantidad_disponible} \n";
    sleep 3;

    $sumar_mutex->down($proceso);

    $contador_lectores = $contador_lectores -1;
    if($contador_lectores == 0) {
        $escribir_mutex->up();
    }

    $sumar_mutex->up();
}

sub grabar_db() {
    my ($self, $proceso) = @_;
    $escribir_mutex->down($proceso);

    print "\n Estoy Escribiendo $proceso->{_cantidad} en $self->{_cantidad_disponible} \n";
    sleep 3;
    $self->{_cantidad_disponible} += $proceso->{_cantidad};

    $escribir_mutex->up();

}

sub print_disponible() {
    my ($self) = @_;
    print " \n DISPONIBLE EN LA DB: " . $self->{_cantidad_disponible} . "\n";
}

1;
