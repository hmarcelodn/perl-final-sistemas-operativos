#!/usr/bin/perl

package main;

use lib '/Users/admin/Desktop/Projects/perl-final-sistemas-operativos/src/modules';

# Modulos de Perl
use strict;
use warnings;
use threads;
use threads::shared;
use Thread::Queue;
use Thread::Semaphore;
use feature qw(switch);
use Term::ReadKey;

# threads->exit();

# Modulos
use Planificador;
use Cola;
use Proceso;
use Despachador;
use Escritor; # TODO: Heredar Proceso
use Lector; # TODO: Heredar Proceso
use Db; # TODO: Implementar
use Cpu;
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

my $modo_monitor :shared = 0;

# Semaforos del Planificador
my $cpu_semaforo = Thread::Semaphore->new();
my $monitor_semaforo = Thread::Semaphore->new();

# Primero monitorea, luego cicla el CPU
$cpu_semaforo->down();

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

    # Hilo 1 - Simulador
    my $simulacion_hilo = threads->create(sub {
        while(1) {
            # Permitir ciclos de CPU
            $cpu_semaforo->down();

            $planificador->actualizar_ciclos($ciclos); # Actualizar los ciclos del planificador
            $planificador->planificar(); # Planifica el siguiente proceso

            # Permitir monitorear luego de planificar
            $monitor_semaforo->up();

            # Permitir despachar y ejecutar
            $cpu_semaforo->down();
            $despachador->despachar();
            $cpu->ejecutar();

            # Pasar al siguiente ciclo de CPU
            $ciclos = $ciclos + 1;

            # Permitir monitorear luego de despachar
            $monitor_semaforo->up();
        }
    });

    $simulacion_hilo->detach();

    # Hilo 2 - Monitor Activo Sincronizado
    my $simulacion_monitor = threads->create(sub {
        while (1) {
            # Monitorear colas antes de ejecutar
            $monitor_semaforo->down();

            if ($modo_monitor == 1) {
                $monitor->imprimir_estado_colas($ciclos);
            }

            # Permitir al CPU ejecutar la cola de listos
            $cpu_semaforo->up();

            # Monitorear colas despues de ejecutar
            $monitor_semaforo->down();

            if ($modo_monitor == 1) {
                $monitor->imprimir_estado_colas($ciclos);
            }

            # Pausa para visualizar
            sleep 1;

            # Permitir al CPU continuar su procesamiento
            $cpu_semaforo->up();
        }
    });

    $simulacion_monitor->detach();

    # Hilo 3 - Interaccion principal
    while(1) {
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
                $modo_monitor = 1;

                # Mientras no se presione una tecla, mantener el modo monitor
                while(not defined ($key = ReadKey(-1))) {}

                $modo_monitor = 0;
            }
            when (3) {
                print "SALIR \n";
                exit;
            }
            default {
                print 0;
            }
        }
    }
}

mock_procesos();
simular();
