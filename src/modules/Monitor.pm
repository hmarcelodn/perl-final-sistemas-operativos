package Monitor;

# use strict;
use warnings;

=pod
Abstraccion que permite visualizar el estado de las colas en todo momento
=cut
sub new() {
    my $class = shift;
    my $self = {
        _nuevos => shift,
        _listos => shift,
        _ejecutando => shift,
        _salida => shift,
    };

    bless $self, $class;

    return $self;
}

=pod
Imprimir reporte de estado de colas
=cut
sub imprimir_estado_colas() {
    my ( $self, $ciclos, $proceso_id, $estado_cpu ) = @_;
    my $procesos_listos_pendientes = $self->{_listos}->pending();
    my $procesos_nuevos_pendientes = $self->{_nuevos}->pending();

    system("clear");

    print "===================================================================\n";
    print "MONITOREANDO COLAS DE PLANIFICACION (presione Enter para salir...) \n";
    print "===================================================================\n\n";
    print "+ CPU CICLO ⏰ : ".$ciclos." \n";
    print "+ PROCESOS NUEVOS: ".$procesos_nuevos_pendientes." \n";
    print "+ PROCESOS LISTOS: ".$procesos_listos_pendientes." \n";
    print "+ ESTADO DEL PROCESADOR: ".$estado_cpu." \n";
    print "+ ULTIMO PROCESO EN EJECUCION: ".$proceso_id." \n\n";
    print "-----------------------------------\n";
    print "COLA: LISTOS\n";
    print "-----------------------------------\n";
    print "Proceso      Llegada     Servicio\n";
    print "-----------------------------------\n";
    my $proceso_listo_indice = 0;
    if ($procesos_listos_pendientes > 0) {
        while ($proceso_listo_indice < $procesos_listos_pendientes) {
            my $proceso_listo = $self->{_listos}->peek($proceso_listo_indice);
            my $proceso_id = $proceso_listo->proceso_id();
            my $proceso_llegada = $proceso_listo->llegada();
            my $proceso_servicio = $proceso_listo->tiempo_servicio();
            print "$proceso_id              $proceso_llegada            $proceso_servicio\n";
            $proceso_listo_indice = $proceso_listo_indice + 1;
        }

        print "-----------------------------------\n";
    }

    print "\n\n\n\n";
    print "-----------------------------------\n";
    print "COLA: NUEVOS                     \n";
    print "-----------------------------------\n";
    print "Proceso      Llegada     Servicio\n";
    print "-----------------------------------\n";
    my $proceso_nuevo_indice = 0;
    if ($procesos_nuevos_pendientes > 0) {
        while ($proceso_nuevo_indice < $procesos_nuevos_pendientes) {
            my $proceso_nuevo = $self->{_nuevos}->peek($proceso_nuevo_indice);
            my $proceso_id = $proceso_nuevo->proceso_id();
            my $proceso_llegada = $proceso_nuevo->llegada();
            my $proceso_servicio = $proceso_nuevo->tiempo_servicio();
            print "$proceso_id              $proceso_llegada            $proceso_servicio\n";
            $proceso_nuevo_indice = $proceso_nuevo_indice + 1;
        }

        print "-----------------------------------\n";
    }

    # print "\n\n Presione Enter para salir...";
}

1;
