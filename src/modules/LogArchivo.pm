package LogArchivo;

# use strict;
use warnings;
use Term::ANSIColor;

=pod
Abstraccion que permite visualizar el estado de las colas en todo momento
=cut
sub new() {
    my $class = shift;
    my $self = {
        _nuevos                => shift,
        _listos                => shift,
        _ejecutando            => shift,
        _salida                => shift,
        _escribir_mutex        => shift,
        _sumar_mutex           => shift,
        _contador_lectores     => shift,
        _escritores_bloqueados => shift,
        _lectores_bloqueados   => shift,
        _fh                    => undef,
    };

    my ($sec,$min,$hour,$mday,$mon,$year)=localtime(time);
    my $timestamp = sprintf ( "%04d%02d%02d%02d%02d%02d",
        $year+1900,$mon+1,$mday,$hour,$min,$sec);

    my $filename = "../logs/monitor" . $timestamp . ".log";
    open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
    $self->{_fh} = $fh;

    bless $self, $class;

    return $self;
}

=pod
Imprimir reporte de estado de colas
=cut
sub imprimir_estado_colas() {
    my ( $self, $ciclos, $proceso_id, $estado_cpu ) = @_;
    my $fh = $self->{_fh};
    my $procesos_listos_pendientes = $self->{_listos}->pending();
    my $procesos_nuevos_pendientes = $self->{_nuevos}->pending();
    my $procesos_encolados_write = $self->{_escritores_bloqueados}->pending();
    my $procesos_bloqueados_lector = $self->{_lectores_bloqueados}->pending();
    my $procesos_ejecutando_total = $self->{_ejecutando}->pending();

    print $fh "===================================================================\n";
    print $fh "MONITOREANDO COLAS DE PLANIFICACION (presione CTRL + C para salir.) \n";
    print $fh "===================================================================\n";
    print $fh "+ CPU CICLO ⏰ : ".$ciclos." \n";
    print $fh "+ PROCESOS NUEVOS: ".$procesos_nuevos_pendientes." \n";
    print $fh "+ PROCESOS LISTOS: ".$procesos_listos_pendientes." \n";
    print $fh "+ ESTADO DEL PROCESADOR: ".$estado_cpu." \n";
    print $fh "+ ULTIMO PROCESO EN EJECUCION: ".$proceso_id." \n";
    print $fh "+ CANTIDAD DE ESCRITORES ESPERANDO: ".$procesos_encolados_write." \n";
    print $fh "+ CANTIDAD DE LECTORES ESPERANDO: ".$procesos_bloqueados_lector." \n";
    print $fh "\n\n";

    print $fh "-----------------------------------\n";
    print $fh "COLA: EJECUTANDO \n";
    print $fh "-----------------------------------\n";
    print $fh "Proceso      Llegada     Servicio\n";
    print $fh "-----------------------------------\n";
    my $proceso_ejecutando_indice = 0;
    if ($self->{_ejecutando}->pending() > 0) {
        while ($proceso_ejecutando_indice < $procesos_ejecutando_total) {
            my $proceso_ejecutando = $self->{_ejecutando}->peek($proceso_ejecutando_indice);
            my $proceso_id_ejec = $proceso_ejecutando->proceso_id();
            my $proceso_llegada_ejec = $proceso_ejecutando->llegada();
            my $proceso_servicio_ejec = $proceso_ejecutando->tiempo_servicio();
            print $fh "$proceso_id_ejec              $proceso_llegada_ejec            $proceso_servicio_ejec\n";
            $proceso_ejecutando_indice = $proceso_ejecutando_indice + 1;
        }

        # print "\n-----------------------------------\n";
    }

    print $fh "\n";
    print $fh "-----------------------------------\n";
    print $fh "COLA: LISTOS\n";
    print $fh "-----------------------------------\n";
    print $fh "Proceso      Llegada     Servicio\n";
    print $fh "-----------------------------------\n";
    my $proceso_listo_indice = 0;
    if ($self->{_listos}->pending() > 0) {
        while ($proceso_listo_indice < $procesos_listos_pendientes) {
            my $proceso_listo = $self->{_listos}->peek($proceso_listo_indice);
            my $proceso_id = $proceso_listo->proceso_id();
            my $proceso_llegada = $proceso_listo->llegada();
            my $proceso_servicio = $proceso_listo->tiempo_servicio();
            print $fh "$proceso_id              $proceso_llegada            $proceso_servicio\n";
            $proceso_listo_indice = $proceso_listo_indice + 1;
        }

        # print "-----------------------------------\n";
    }

    print $fh "\n";
    print $fh "-----------------------------------\n";
    print $fh "COLA: NUEVOS                     \n";
    print $fh "-----------------------------------\n";
    print $fh "Proceso      Llegada     Servicio\n";
    print $fh "-----------------------------------\n";
    my $proceso_nuevo_indice = 0;
    if ($self->{_nuevos}->pending() > 0) {
        while ($proceso_nuevo_indice < $procesos_nuevos_pendientes) {
            my $proceso_nuevo = $self->{_nuevos}->peek($proceso_nuevo_indice);
            my $proceso_id = $proceso_nuevo->proceso_id();
            my $proceso_llegada = $proceso_nuevo->llegada();
            my $proceso_servicio = $proceso_nuevo->tiempo_servicio();
            print $fh "$proceso_id              $proceso_llegada            $proceso_servicio\n";
            $proceso_nuevo_indice = $proceso_nuevo_indice + 1;
        }

        # print "\n-----------------------------------\n";
    }

    print $fh "\n";
    print $fh "-----------------------------------\n";
    print $fh "COLA: ESCRITORES \n";
    print $fh "-----------------------------------\n";
    print $fh "Proceso      Llegada     Servicio\n";
    print $fh "-----------------------------------\n";
    my $proceso_bloq_indice = 0;
    if ($self->{_escritores_bloqueados}->pending() > 0) {
        while ($proceso_bloq_indice < $procesos_encolados_write) {
            my $proceso_bloq = $self->{_escritores_bloqueados}->peek($proceso_bloq_indice);
            my $proceso_id_bloq = $proceso_bloq->proceso_id();
            my $proceso_llegada_bloq = $proceso_bloq->llegada();
            my $proceso_servicio_bloq = $proceso_bloq->tiempo_servicio();
            print $fh "$proceso_id_bloq              $proceso_llegada_bloq            $proceso_servicio_bloq\n";
            $proceso_bloq_indice = $proceso_bloq_indice + 1;
        }

        # print "\n-----------------------------------\n";
    }

    print $fh "\n";
    print $fh "-----------------------------------\n";
    print $fh "COLA: LECTORES \n";
    print $fh "-----------------------------------\n";
    print $fh "Proceso      Llegada     Servicio\n";
    print $fh "-----------------------------------\n";
    my $proceso_lector_bloq_indice = 0;
    if ($self->{_lectores_bloqueados}->pending() > 0) {
        while ($proceso_lector_bloq_indice < $procesos_bloqueados_lector) {
            my $proceso_bloq = $self->{_lectores_bloqueados}->peek($proceso_lector_bloq_indice);
            my $proceso_id_bloq = $proceso_bloq->proceso_id();
            my $proceso_llegada_bloq = $proceso_bloq->llegada();
            my $proceso_servicio_bloq = $proceso_bloq->tiempo_servicio();
            print $fh "$proceso_id_bloq              $proceso_llegada_bloq            $proceso_servicio_bloq\n";
            $proceso_lector_bloq_indice = $proceso_lector_bloq_indice + 1;
        }

        # print "\n-----------------------------------\n";
    }

}

=pod
Cierra Archivo
=cut
sub close_file() {
    my ( $self ) = @_;

    close $self->{_fh};
}
1;
