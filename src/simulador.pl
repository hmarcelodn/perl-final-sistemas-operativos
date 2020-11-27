#!/usr/bin/perl

package main;

use FindBin qw( $RealBin );
use lib "$RealBin/../src/modules";

# Modulos de Perl
use strict;
use warnings;
use threads;
use threads::shared;
use Thread::Queue;
use Thread::Semaphore;
use feature qw(switch);
use Term::ReadKey;
use Term::ANSIColor;

# Modulos
use Planificador;
use Cola;
use Proceso;
use Despachador;
use Escritor;
use Lector;
use Db;
use Cpu;
use Monitor;

# Colas Planificacion de corto plazo
my $cola_listos = Thread::Queue->new();
my $cola_ejecutando = Thread::Queue->new();

# Colas Planificacion de mediano plazo
my $cola_bloqueados = Thread::Queue->new();

# Colas Planificacion de largo plazo
my $cola_nuevos = Thread::Queue->new();
my $cola_salida = Thread::Queue->new();

# CPU / Base de datos
my $cpu_1 = Cpu->new($cola_ejecutando);
my $cpu_2 = Cpu->new($cola_ejecutando);

my $cola_procesadores = Thread::Queue->new();
$cola_procesadores->enqueue( $cpu_1 );
$cola_procesadores->enqueue( $cpu_2 );

# Planificador / Despachador
my $planificador = Planificador->new($cola_nuevos, $cola_listos, 0);
my $despachador = Despachador->new($cola_nuevos, $cola_listos, $cola_ejecutando, $cola_salida, $cola_procesadores);

# Instancia del monitor
my $monitor = Monitor->new($cola_nuevos, $cola_listos, $cola_ejecutando, $cola_salida);

# Reloj CPU
my $ciclos :shared = 0;
my $cpu_estado :shared = "";
my $cpu_proceso_id :shared = "";

# Modo Monitor Activo
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
    # $cola_nuevos->enqueue( Lector->new(2, 2, "P0", "NUEVO", 90) ); # Termina en 4
    $cola_nuevos->enqueue( Lector->new(1, 3, "P1", "NUEVO", 5) ); # Empieza en 4 y termina en 6
    $cola_nuevos->enqueue( Lector->new(2, 5, "P1", "NUEVO", 6) ); # Empieza en 4 y termina en 6
    $cola_nuevos->enqueue( Escritor->new(3, 1, "P2", "NUEVO", 8) ); # Empieza en 6 y termina en 8
    $cola_nuevos->enqueue( Lector->new(2, 3, "P1", "NUEVO", 7) ); # Empieza en 4 y termina en 6
    # $cola_nuevos->enqueue( Escritor->new(3, 1, "P3", "NUEVO", 40) );
    # $cola_nuevos->enqueue( Escritor->new(3, 1, "P4", "NUEVO", 60) );
    # $cola_nuevos->enqueue( Lector->new(4,1, "P5", "NUEVO", 80) );
    # $cola_nuevos->enqueue( Escritor->new(6,2, "P4", "NUEVO", 100) );
    # $cola_nuevos->enqueue( Lector->new(12,5, "P4", "NUEVO", 40) );
    # $cola_nuevos->enqueue( Lector->new(22,5, "P5", "NUEVO", 8) );
}

=pod
Subrutina para simular ciclos de CPU
=cut
sub simular() {
    # Auto flush de STDOUT
    $| = 1;

    print color('bold green');

    # Hilo 1 - Simulador
    my $simulacion_hilo = threads->create(sub {
        # Creo instancia de DB
        my $base_datos = Db->new('Db1', 100000000);

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

            # Me obliga a correr 2 procesos a la vez, por ej, E/L
            $cola_procesadores->peek(0)->ejecutar($base_datos);
            $cola_procesadores->peek(1)->ejecutar($base_datos);

            # Pasar al siguiente ciclo de CPU
            $ciclos = $ciclos + 1;

            my $test1 = $cola_procesadores->peek(0)->estado();
            my $test2 = $cola_procesadores->peek(1)->estado();

            print "\n Estado PROC 1: $test1 \n";
            print "\n Estado PROC 2: $test2 \n";

            $cpu_estado = $cola_procesadores->peek(1)->estado();
            $cpu_proceso_id = $cola_procesadores->peek(1)->proceso_asignado();

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
                $monitor->imprimir_estado_colas( $ciclos, $cpu_proceso_id, $cpu_estado );
            }

            # Permitir al CPU ejecutar la cola de listos
            $cpu_semaforo->up();

            # Monitorear colas despues de ejecutar
            $monitor_semaforo->down();

            if ($modo_monitor == 1) {
                $monitor->imprimir_estado_colas( $ciclos, $cpu_proceso_id, $cpu_estado );
            }

            # Pausa para visualizar
            sleep 2;

            # Permitir al CPU continuar su procesamiento
            $cpu_semaforo->up();
        }
    });

    $simulacion_monitor->detach();

    # Hilo 3 - Interaccion principal
    while(1) {
        system("clear");
        my @threads = threads->list();
        my @running = threads->list(threads::running);
        my @joinable = threads->list(threads::joinable);
        print "Using threads.pm version $threads::VERSION\n";
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
                my $nuevo_proceso_tipo;

                print "INGRESAR TIPO PROCESO L (LECTOR) / E (ESCRITOR): ";
                $nuevo_proceso_tipo = <STDIN>;
                chomp $nuevo_proceso_tipo;

                print "INGRESAR PID: ";
                $nuevo_proceso_pid = <STDIN>;
                chomp $nuevo_proceso_pid;

                print "INGRESAR TIEMPO LLEGADA: ";
                $nuevo_proceso_llegada = <STDIN>;
                chomp $nuevo_proceso_llegada;

                print "INGRESAR TIEMPO DE SERVICIO: ";
                $nuevo_proceso_servicio = <STDIN>;
                chomp $nuevo_proceso_servicio;

                if( $nuevo_proceso_tipo == 'L') {
                    $cola_nuevos->enqueue( Lector->new($nuevo_proceso_llegada, $nuevo_proceso_servicio, $nuevo_proceso_pid, "NUEVO") );
                } else {
                    $cola_nuevos->enqueue( Escritor->new($nuevo_proceso_llegada, $nuevo_proceso_servicio, $nuevo_proceso_pid, "NUEVO") );
                }
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
