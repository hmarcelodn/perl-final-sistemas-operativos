#!/usr/bin/perl

package Db;

use strict;
use warnings;
use Semaforo;

sub new {
    my $class = shift;

    my $self = {
        _nombre_db           => shift,
        _cantidad_disponible => shift,
        _escribir_mutex      => shift,
        _sumar_mutex         => shift,
        _contador_lectores   => shift,
        _os                  => shift,
    };

    bless $self, $class;

    return $self;
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
    my ( $self, $proceso ) = @_;
    # print " \n Exite OS???? : $self->{_os} \n ";
    # print " \n Contador Lectores en DB : $self->{_contador_lectores} \n ";

    $self->{_os}->asignar_proceso( $proceso );
    $self->{_os}->semWait( $self->{_sumar_mutex} );
    $self->{_contador_lectores} = $self->{_contador_lectores} + 1;

    if($self->{_contador_lectores} == 1) {
        $self->{_os}->semWait( $self->{_escribir_mutex} );
    }
    $self->{_os}->semSignal( $self->{_escribir_mutex} );

    # print "\n Lei $proceso->{_cantidad} de $self->{_cantidad_disponible} \n";
    sleep 3;

    $self->{_os}->semWait( $self->{_sumar_mutex} );
    $self->{_contador_lectores} = $self->{_contador_lectores} - 1;

    if($self->{_contador_lectores} == 0) {
        $self->{_escribir_mutex}->up();
    }

    $self->{_os}->semSignal( $self->{_sumar_mutex} );
}

sub grabar_db() {
    my ($self, $proceso) = @_;

    $self->{_os}->asignar_proceso( $proceso );
    $self->{_os}->semWait( $self->{_escribir_mutex} );

    # print "\n Estoy Escribiendo $proceso->{_cantidad} en $self->{_cantidad_disponible} \n";
    sleep 3;
    $self->{_cantidad_disponible} += $proceso->{_cantidad};

    $self->{_os}->semSignal( $self->{_escribir_mutex} );
}

sub print_disponible() {
    my ($self) = @_;
    print " \n DISPONIBLE EN LA DB: " . $self->{_cantidad_disponible} . "\n";
}

1;
