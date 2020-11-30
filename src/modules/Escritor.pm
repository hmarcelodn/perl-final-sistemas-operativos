#!/usr/bin/perl

package Escritor;

use strict;
use warnings;

=pod
Representa un proceso Escritor generalizado a partir del paquete Proceso
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

    if ( $self->contar_ejecuciones() == 0 ) {
        # print "PRIMER ESCRITURA \n";
        $self->obtener_os()->asignar_proceso( $self );
        $self->obtener_os()->semWait( $self->obtener_escribir_mutex() );
    }

    # $self->{_cantidad_disponible} += $proceso->{_cantidad};
    # print "\n GRABAR MUTEX ESCRITOR $self->{_contador_lectores} $self->{_escribir_mutex}->{_count} \n";
    # print "\n ESCRIBIENDO $self->{_proceso_id} \n";
    # sleep 10;

    if ( $self->tiempo_servicio() == 0 ) {
        # print "\n TERMINO ESCRITURA $self->{_proceso_id} \n";
        $self->obtener_os()->asignar_proceso( $self );
        $self->obtener_os()->semSignal( $self->obtener_escribir_mutex() );
    }

    # $dba->grabar_db($self);
}

1;
