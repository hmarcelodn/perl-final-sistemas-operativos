#!/usr/bin/perl

package main;

use FindBin qw( $RealBin );
use lib "$RealBin/../src/modules";

use strict;
use warnings;

use Planificador;
use Cola;
use Proceso; # TODO: Proceso Base
use Despachador;
use Escritor; # TODO: Heredar Proceso
use Lector; # TODO: Heredar Proceso
use Db; # TODO: Implementar
use Cpu; # TODO: Implementar?
use Monitor;

# Colas Planificacion de corto plazo
my $cola_listos = Cola->new();
my $cola_ejecutando = Cola->new();

# Colas Planificacion de largo plazo
my $cola_nuevos = Cola->new();
my $cola_salida = Cola->new();

# CPU / Base de datos
my $cpu = Cpu->new($cola_ejecutando);
my $base_datos = Db->new();

# Planificador / Despachador
my $planificador = Planificador->new($cola_nuevos, $cola_listos, 0, $cpu);
my $despachador = Despachador->new($cola_nuevos, $cola_listos, $cola_ejecutando, $cola_salida, $cpu);

# Instancia del monitor
my $monitor = Monitor->new($cola_nuevos, $cola_listos, $cola_ejecutando, $cola_salida);

# Reloj CPU
my $ciclos = 0;

=pod
Subrutina para agregar proceso nuevos a la cola de nuevos (testing)
=cut
sub mock_procesos() {
    $cola_nuevos->encolar( Escritor->new(2,2, "P0", "NUEVO") );
    $cola_nuevos->encolar( Lector->new(3,2, "P1", "NUEVO") );
    $cola_nuevos->encolar( Escritor->new(4,2, "P2", "NUEVO") );
    $cola_nuevos->encolar( Escritor->new(5,2, "P3", "NUEVO") );
    $cola_nuevos->encolar( Escritor->new(6,2, "P4", "NUEVO") );
    $cola_nuevos->encolar( Lector->new(7,2, "P5", "NUEVO") );
    $cola_nuevos->encolar( Lector->new(10,2, "P6", "NUEVO") );
    $cola_nuevos->encolar( Lector->new(12,2, "P7", "NUEVO") );
    $cola_nuevos->encolar( Lector->new(22,2, "P8", "NUEVO") );
}

=pod
Subrutina para simular ciclos de CPU
=cut
sub simular() {
    print "=====================================\n";
    print "== PLANIFICADOR CPU - SIMULADOR 🤖 ===\n";
    print "=====================================\n";

    while(1) {
        printf "\nCICLO CPU ($ciclos) ⏰  \n";

        $planificador->actualizar_ciclos($ciclos);
        $planificador->planificar(); # Planifica el siguiente proceso
        $despachador->despachar(); # Despacha al CPU el proceso planificado
        $cpu->ejecutar();

        $ciclos = $ciclos + 1;
        # $monitor->imprimir_estado_colas();
        sleep(2);
    }
}

mock_procesos();
simular();
