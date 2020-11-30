#!/usr/bin/perl

package Lector;

use strict;
use warnings;

=pod
Representa un proceso Lector generalizado a partir del paquete Proceso
=cut
our @ISA = qw(Proceso);    # inherits from Proceso

sub new {
    my ($class) = @_;
    my $self = $class->SUPER::new( $_[1], $_[2], $_[3], $_[4], $_[5], $_[6], $_[7], $_[8], $_[9], $_[10] );

    bless $self, $class;

    return $self
}

=pod
Ejecuta comportamiento de proceso
=cut
sub ejecutar() {
    my ( $self, $dba ) = @_;
    # print "\n Ejecuciones de Lectura" . $self->contar_ejecuciones() . "\n";
    if ( $self->contar_ejecuciones() == 0 ) {
        $self->obtener_os()->asignar_proceso( $self );
        $self->obtener_os()->semWait( $self->obtener_sumar_mutex() );

        $self->{_contador_lectores} = $self->{_contador_lectores} + 1;
        print "Contador Lectores" . $self->{_contador_lectores} ."\n";

        if($self->{_contador_lectores} == 1) {
            print "Escribir \n";
            $self->obtener_os()->asignar_proceso( $self );
            $self->obtener_os()->semWait( $self->obtener_escribir_mutex() );
        }
        $self->obtener_os()->asignar_proceso( $self );
        $self->obtener_os()->semSignal( $self->obtener_sumar_mutex() );
    }

    print "\n LEYENDO \n";
    # sleep 10;
    # print "\n TERMINE LEYENDO \n";

    # TODO:
    if ( $self->tiempo_servicio() == 0 ) {
        $self->obtener_os()->asignar_proceso( $self );
        $self->obtener_os()->semWait( $self->obtener_sumar_mutex() );

        $self->{_contador_lectores} = $self->{_contador_lectores} - 1;
        print "Contador Lectores resto" . $self->{_contador_lectores} ."\n";

        if($self->{_contador_lectores} == 0) {
            $self->obtener_os()->asignar_proceso( $self );
            $self->obtener_os()->semSignal( $self->obtener_escribir_mutex() );
        }

        $self->obtener_os()->asignar_proceso( $self );
        $self->obtener_os()->semSignal( $self->obtener_sumar_mutex() );
    }
}

1;
