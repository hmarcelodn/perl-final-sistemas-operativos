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

    # $self->{_os}->asignar_proceso( $proceso );

    # # TODO:
    # if ( $proceso->contar_ejecuciones() == 0 ) {
    #     $self->{_os}->semWait( $self->{_sumar_mutex} );
    #     $self->{_contador_lectores} = $self->{_contador_lectores} + 1;
    #     if($self->{_contador_lectores} == 1) {
    #         $self->{_os}->semWait( $self->{_escribir_mutex} );
    #     }

    #     $self->{_os}->semSignal( $self->{_sumar_mutex} );
    # }
    # # Termina: zona critica

    # # print "\n LEYENDO \n";
    # # sleep 10;
    # # print "\n TERMINE LEYENDO \n";

    # # TODO:
    # if ( $proceso->tiempo_servicio() == 0 ) {
    #     $self->{_os}->asignar_proceso( $proceso );
    #     $self->{_os}->semWait( $self->{_sumar_mutex} );

    #     $self->{_contador_lectores} = $self->{_contador_lectores} - 1;

    #     if($self->{_contador_lectores} == 0) {
    #         $self->{_os}->asignar_proceso( $proceso );
    #         $self->{_os}->semSignal( $self->{_escribir_mutex} );
    #         # print "\n TERMINE DE LEER \n";
    #         # print $proceso;
    #     }

    #     $self->{_os}->asignar_proceso( $proceso );
    #     $self->{_os}->semSignal( $self->{_sumar_mutex} );
    # }

}

sub grabar_db() {
    my ($self, $proceso) = @_;

    # if ( $proceso->contar_ejecuciones() == 0 ) {
    #     $self->{_os}->asignar_proceso( $proceso );
    #     $self->{_os}->semWait( $self->{_escribir_mutex} );
    # }

    # # $self->{_cantidad_disponible} += $proceso->{_cantidad};
    # # print "\n GRABAR MUTEX ESCRITOR $self->{_contador_lectores} $self->{_escribir_mutex}->{_count} \n";
    # # print "\n ESCRIBIENDO $proceso->{_proceso_id} \n";
    # # sleep 10;

    # if ( $proceso->tiempo_servicio() == 0 ) {
    #     # print "\n TERMINO ESCRIBIENDO $proceso->{_proceso_id} \n";
    #     $self->{_os}->asignar_proceso( $proceso );
    #     $self->{_os}->semSignal( $self->{_escribir_mutex} );
    # }
}

sub print_disponible() {
    my ($self) = @_;
    print " \n DISPONIBLE EN LA DB: " . $self->{_cantidad_disponible} . "\n";
}

1;
