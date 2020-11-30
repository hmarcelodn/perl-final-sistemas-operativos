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
    my $self = $class->SUPER::new( $_[1], $_[2], $_[3], $_[4], $_[5], $_[6], $_[7], $_[8], $_[9], $_[10], $_[11], $_[12] );

    bless $self, $class;

    return $self
}

=pod
Ejecuta comportamiento de proceso
=cut
sub ejecutar() {
    my ( $self ) = @_;

    # print "\n LECTORES: ".$self->{_cola_lectores}->pending()." ESCRITORES: ".$self->{_cola_escritores}->pending()." $self->{_proceso_id} EJECU: ".$self->contar_ejecuciones()." \n";
    if (
        ($self->{_cola_lectores}->pending() == 0 && $self->{_cola_escritores}->pending() == 0 ) ||
        ( $self->{_cola_escritores}->pending() == 1 && $self->{_cola_escritores}->peek(0)->proceso_id() eq $self->proceso_id() ) ) {

        # Si recien comienza, lo encola junto a los escritores
        if ( $self->contar_ejecuciones() == 0 ) {
            $self->{_cola_escritores}->enqueue( $self );
        }

        # Si ya termino, desencola el escritor
        if ( $self->tiempo_servicio() == 0 ) {
            $self->{_cola_escritores}->dequeue_nb();
        }

     } else {
        $self->{_os}->bloquear_proceso_escritor( $self );
     }

}

1;
