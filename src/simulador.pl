#!/usr/bin/perl

package main;

use lib '/Users/admin/Desktop/Projects/perl-final-sistemas-operativos/src/modules';

# Modulos de Perl
use strict;
use warnings;
use threads;
use threads::shared;
use Thread::Queue;
use feature qw(switch);
use Term::ReadKey;

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
    $cola_nuevos->enqueue( Proceso->new(2, 2, "P0", "NUEVO") );
    $cola_nuevos->enqueue( Proceso->new(3, 2, "P1", "NUEVO") );
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
    # Auto flush de STDOUT
    $| = 1;

    # Thread 1 - Simulador
    my $simulacion_hilo = threads->create(sub {
        while(1) {
            # print "\nCICLO CPU ($ciclos) ⏰  \n";

            $planificador->actualizar_ciclos($ciclos); # Actualizar los ciclos del planificador
            $planificador->planificar(); # Planifica el siguiente proceso

            # $monitor->imprimir_estado_colas($ciclos); # Mostrar colas antes de procesar
            sleep 2;

            $despachador->despachar();
            $cpu->ejecutar();
            # $monitor->imprimir_estado_colas($ciclos); # Mostrar colas despues de procesar

            $ciclos = $ciclos + 1;
        }
    });

    $simulacion_hilo->detach();

    # TODO: Consola interactiva con usuario
    while(1) {
        # $monitor->imprimir_estado_colas($ciclos);
        system("clear");
        print "=====================================\n";
        print "== PLANIFICADOR CPU - SIMULADOR 🤖 ==\n";
        print "=====================================\n";
        print "AYUDA GESTOR DE PROCESOS \n\n";
        print "1) AGREGAR UN NUEVO PROCESO \n";
        print "2) MONITOREAR COLAS DE PLANIFICACION \n";
        print "3) TERMINAR \n\n";

        my $opcion = 0;

        # Solicitar ingreso del comando en menu
        while ($opcion < 1 || $opcion > 3) {
            print "+ INGRESAR OPCION: ";
            $opcion = <STDIN>;
            chomp $opcion;

            if ($opcion < 1 || $opcion > 3) {
                print "- OPCION INCORRECTA \n";
            }
        }

        given ($opcion)
        {
            when (1) {
                print "AGREGAR UN NUEVO PROCESO \n";
                my $nuevo_proceso_pid;
                my $nuevo_proceso_llegada;
                my $nuevo_proceso_servicio;

                print "INGRESAR PID: ";
                $nuevo_proceso_pid = <STDIN>;
                chomp $nuevo_proceso_pid;

                print "INGRESAR TIEMPO LLEGADA: ";
                $nuevo_proceso_llegada = <STDIN>;
                chomp $nuevo_proceso_llegada;

                print "INGRESAR TIEMPO DE SERVICIO: ";
                $nuevo_proceso_servicio = <STDIN>;
                chomp $nuevo_proceso_servicio;

                $cola_nuevos->enqueue( Proceso->new($nuevo_proceso_llegada, $nuevo_proceso_servicio, $nuevo_proceso_pid, "NUEVO") );
                print "\n NUEVO PROCESO AGREGADO A LA COLA DE NUEVOS PROCESOS! \n";
            }
            when (2) {
                my $key;
                while(not defined ($key = ReadKey(-1))) {
                    $monitor->imprimir_estado_colas($ciclos);
                    sleep 2;
                }
            }
            when (3) {
                print "SALIR \n";
                exit;
            }
            default {
                print 0;
            }
        }

        sleep 1;
    }
}

mock_procesos();
simular();
