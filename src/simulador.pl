#!/usr/bin/perl

package main;

use lib '/Users/admin/Desktop/Projects/perl-final-sistemas-operativos/src/modules';

# Modulos de Perl
use strict;
use warnings;
use threads;
use threads::shared;
use Thread::Queue;

# threads->exit();

# Modulos
use Planificador;
use Cola;
use Proceso; # TODO: Proceso Base
use Despachador;
use Escritor; # TODO: Heredar Proceso
use Lector; # TODO: Heredar Proceso
use Db; # TODO: Implementar
use Cpu; # TODO: Implementar?
use Monitor;

# # Colas Planificacion de corto plazo
# my $cola_listos = Cola->new();
# my $cola_ejecutando = Cola->new();

# # Colas Planificacion de largo plazo
# my $cola_nuevos = Cola->new();
# my $cola_salida = Cola->new();

# Colas Planificacion de corto plazo
my $cola_listos = Thread::Queue->new();
my $cola_ejecutando = Thread::Queue->new();

# Colas Planificacion de largo plazo
my $cola_nuevos = Thread::Queue->new();
my $cola_salida = Thread::Queue->new();

# CPU / Base de datos
my $cpu = Cpu->new($cola_ejecutando);
my $base_datos = Db->new();

# Planificador / Despachador
my $planificador = Planificador->new($cola_nuevos, $cola_listos, 0, $cpu);
my $despachador = Despachador->new($cola_nuevos, $cola_listos, $cola_ejecutando, $cola_salida, $cpu);

# Instancia del monitor
my $monitor = Monitor->new($cola_nuevos, $cola_listos, $cola_ejecutando, $cola_salida);

# Reloj CPU
my $ciclos :shared = 0;

=pod
Subrutina para agregar proceso nuevos a la cola de nuevos (testing)
=cut
sub mock_procesos() {
    $cola_nuevos->enqueue( Proceso->new(2,2, "P0", "NUEVO") );
    $cola_nuevos->enqueue( Proceso->new(3,2, "P1", "NUEVO") );
    $cola_nuevos->enqueue( Proceso->new(4,2, "P2", "NUEVO") );
    $cola_nuevos->enqueue( Proceso->new(5,2, "P3", "NUEVO") );
    $cola_nuevos->enqueue( Proceso->new(6,2, "P4", "NUEVO") );
    $cola_nuevos->enqueue( Proceso->new(7,2, "P5", "NUEVO") );
    $cola_nuevos->enqueue( Proceso->new(10,2, "P6", "NUEVO") );
    $cola_nuevos->enqueue( Proceso->new(12,2, "P7", "NUEVO") );
    $cola_nuevos->enqueue( Proceso->new(22,2, "P8", "NUEVO") );
}

=pod
Subrutina para simular ciclos de CPU
=cut
sub simular() {
    print "=====================================\n";
    print "== PLANIFICADOR CPU - SIMULADOR 🤖 ==\n";
    print "=====================================\n";

    # Auto flush de STDOUT
    $| = 1;

    # Thread 1 - Simulador
    my $simulacion_hilo = threads->create(sub {
        while(1) {
            # print "\nCICLO CPU ($ciclos) ⏰  \n";

            $planificador->actualizar_ciclos($ciclos);
            $planificador->planificar(); # Planifica el siguiente proceso
            $despachador->despachar(); # Despacha al CPU el proceso planificado
            $cpu->ejecutar();

            $ciclos = $ciclos + 1;
            sleep 2;
        }
    });

    while(1) {
        $monitor->imprimir_estado_colas($ciclos);
        sleep 2;
    }

    $simulacion_hilo->detach();
}

mock_procesos();
simular();
