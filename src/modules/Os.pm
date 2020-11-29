#!/usr/bin/perl

package Os;

use strict;
use warnings;

use threads::shared;

sub new {
    my $class = shift;

    my $self = {
        _listos                      => shift,
        _proceso                     => undef,
        _cola_procesadores           => shift,
    };

    bless $self, $class;

    return $self;
}

sub asignar_proceso() {
    my ( $self, $proceso ) = @_;

    $self->{_proceso} = $proceso;
}

sub semWait() {
    my ( $self, $semaforo ) = @_;

    $semaforo->down();

    if ( $semaforo->contar() < 0 ) {
        print "DURMIENDO PROCESO! \n";
        print $self->{_proceso};

        # Libero el procesador del proceso bloqueado
        for (my $i = 0; $i < $self->{_cola_procesadores}->pending(); $i++) {
            my $cpu = $self->{_cola_procesadores}->peek( $i );
            if ( $cpu->proceso_asignado() eq $self->{_proceso}->proceso_id() ) {
                print "\n LIBERO PROCESADOR \n";
                $cpu->cambiar_libre();
            }
        }

        # Duerme con espera activa el proceso
        $semaforo->dormir_proceso( $self->{_proceso} );
    }
}


sub semSignal() {
    my ( $self, $semaforo ) = @_;

    $semaforo->up();

    if ( $semaforo->contar() <= 0 ) {
        print "DESPERTAR PROCESO \n";
        my $proceso_listo = $semaforo->despertar_proceso();
        print $proceso_listo;
        $self->{_cola_procesadores}->peek(0)->asignar( $proceso_listo );

        $proceso_listo->cambiar_a_ejecutando();
    }
}

1;
