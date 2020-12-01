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
use Scalar::Util qw(looks_like_number);

# Modulos
use Planificador;
use Proceso;
use Despachador;
use Escritor;
use Lector;
use Db;
use Cpu;
use Monitor;
use LogArchivo;
use Os;

# Colas
my $cola_escribir_mutex = Thread::Queue->new();
my $cola_sumar_mutex = Thread::Queue->new();
my $cola_contador_lectores = Thread::Queue->new();
my $cola_escritores = Thread::Queue->new();
my $cola_lectores = Thread::Queue->new();

# Colas Planificacion de corto plazo
my $cola_listos = Thread::Queue->new();
my $cola_ejecutando = Thread::Queue->new();

# Colas Planificacion de mediano plazo
my $cola_bloqueados_escritores = Thread::Queue->new();
my $cola_bloqueados_lectores = Thread::Queue->new();

# Colas Planificacion de largo plazo
my $cola_nuevos = Thread::Queue->new();
my $cola_salida = Thread::Queue->new();

# Instancia del monitor
my $monitor = Monitor->new($cola_nuevos, $cola_listos, $cola_ejecutando, $cola_salida, $cola_contador_lectores, $cola_bloqueados_escritores, $cola_bloqueados_lectores);

# Instancia del Log de Archivo
my $log_archivo = LogArchivo->new($cola_nuevos, $cola_listos, $cola_ejecutando, $cola_salida, $cola_contador_lectores, $cola_bloqueados_escritores, $cola_bloqueados_lectores);

# Reloj CPU
my $ciclos :shared = 0;
my $cpu_estado :shared = "";
my $cpu_proceso_id :shared = "";

# Modo Monitor Activo
my $modo_monitor :shared = 0;

# Semaforos del Planificador
my $cpu_semaforo = Thread::Semaphore->new();
my $monitor_semaforo = Thread::Semaphore->new();
my $ciclo_siguiente_semaforo = Thread::Semaphore->new();
$ciclo_siguiente_semaforo->down();

# Primero monitorea, luego cicla el CPU
$cpu_semaforo->down();

# CPU / Base de datos
my $cpu_1 = Cpu->new($ciclo_siguiente_semaforo );

my $cola_procesadores = Thread::Queue->new();
$cola_procesadores->enqueue( $cpu_1 );

# Planificador / Despachador
my $planificador = Planificador->new($cola_nuevos, $cola_listos, 0, $cola_ejecutando, $cola_bloqueados_escritores, $cola_escritores, $cola_lectores, $cola_bloqueados_lectores);
my $despachador = Despachador->new($cola_nuevos, $cola_listos, $cola_ejecutando, $cola_salida, $cola_procesadores, $cola_bloqueados_escritores);

# Creacion instancia OS / DB
my $os_instance = Os->new( $cola_listos, $cola_procesadores, $cola_ejecutando, $cola_bloqueados_lectores, $cola_bloqueados_escritores );

=pod
Subrutina para agregar proceso nuevos a la cola de nuevos (testing)
=cut
sub mock_procesos() {
    $cola_nuevos->enqueue( Escritor->new(0, 3, "E1", "NUEVO", 8, $ciclo_siguiente_semaforo, $os_instance, $cola_contador_lectores, $cola_lectores, $cola_escritores  ) );
    $cola_nuevos->enqueue( Lector->new(0, 3, "L2", "NUEVO", 8, $ciclo_siguiente_semaforo, $os_instance, $cola_contador_lectores, $cola_lectores, $cola_escritores  ) );
    $cola_nuevos->enqueue( Lector->new(0, 3, "L3", "NUEVO", 8, $ciclo_siguiente_semaforo, $os_instance, $cola_contador_lectores, $cola_lectores, $cola_escritores  ) );
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

        while(1) {
            # Permitir ciclos de CPU
            $cpu_semaforo->down();

            $planificador->actualizar_ciclos($ciclos); # Actualizar los ciclos del planificador
            $planificador->planificar_mediano_plazo(); # Desbloqueamos procesos
            $planificador->planificar(); # Planifica el siguiente proceso

            # Permitir monitorear luego de planificar
            $monitor_semaforo->up();

            # Permitir despachar y ejecutar
            $cpu_semaforo->down();
            $despachador->despachar();

            # Me obliga a correr 2 procesos a la vez, por ej, E/L
            threads->create(sub {
                if ( ref $cola_procesadores->peek(0)->proceso_instancia() ) {
                    $cola_procesadores->peek(0)->ejecutar();
                } else {
                    $cola_procesadores->peek(0)->cambiar_ocioso();
                }
            })->detach();

            $ciclo_siguiente_semaforo->down();

            # Pasar al siguiente ciclo de CPU
            $ciclos = $ciclos + 1;

            $cpu_estado = $cola_procesadores->peek(0)->estado();
            $cpu_proceso_id = $cola_procesadores->peek(0)->proceso_asignado();

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
            $log_archivo->imprimir_estado_colas( $ciclos, $cpu_proceso_id, $cpu_estado );

            if ($modo_monitor == 1) {
                $monitor->imprimir_estado_colas( $ciclos, $cpu_proceso_id, $cpu_estado );
            }

            # Pausa para visualizar
            sleep 2;

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
        print "=====================================\n";
        print "== PLANIFICADOR CPU - SIMULADOR 🤖 ==\n";
        print "=====================================\n";
        print "AYUDA GESTOR DE PROCESOS \n\n";
        print "1) AGREGAR UN NUEVO PROCESO \n";
        print "2) MONITOREAR COLAS DE PLANIFICACION \n";
        print "3) TERMINAR \n\n";

        my $opcion = 0;

        # Solicitar ingreso del comando en menu
        while (!looks_like_number( $opcion ) || ($opcion < 1 || $opcion > 3)) {
            print "+ INGRESAR OPCION: ";
            $opcion = <STDIN>;
            chomp $opcion;
        }

        given ($opcion)
        {
            when (1) {
                print "AGREGAR UN NUEVO PROCESO \n";
                my $nuevo_proceso_pid;
                my $nuevo_proceso_llegada;
                my $nuevo_proceso_servicio;
                my $nuevo_proceso_tipo = "";

                while ( $nuevo_proceso_tipo ne "L" && $nuevo_proceso_tipo ne "E" ) {
                    print "INGRESAR TIPO PROCESO L (LECTOR) / E (ESCRITOR): ";
                    $nuevo_proceso_tipo = <STDIN>;
                    chomp $nuevo_proceso_tipo;
                }

                print "INGRESAR PID: ";
                $nuevo_proceso_pid = <STDIN>;
                chomp $nuevo_proceso_pid;

                while ( !looks_like_number( $nuevo_proceso_llegada ) ) {
                    print "INGRESAR TIEMPO LLEGADA: ";
                    $nuevo_proceso_llegada = <STDIN>;
                    chomp $nuevo_proceso_llegada;
                }

                while ( !looks_like_number( $nuevo_proceso_servicio ) ) {
                    print "INGRESAR TIEMPO DE SERVICIO: ";
                    $nuevo_proceso_servicio = <STDIN>;
                    chomp $nuevo_proceso_servicio;
                }

                if( $nuevo_proceso_tipo eq "L") {
                    $cola_nuevos->enqueue( Lector->new($nuevo_proceso_llegada, $nuevo_proceso_servicio, $nuevo_proceso_pid, "NUEVO", 8, $ciclo_siguiente_semaforo, $os_instance, $cola_escribir_mutex->peek(0), $cola_sumar_mutex->peek(0), $cola_contador_lectores, $cola_lectores, $cola_escritores  ) );
                } else {
                    $cola_nuevos->enqueue( Escritor->new($nuevo_proceso_llegada, $nuevo_proceso_servicio, $nuevo_proceso_pid, "NUEVO", 8, $ciclo_siguiente_semaforo, $os_instance, $cola_escribir_mutex->peek(0), $cola_sumar_mutex->peek(0), $cola_contador_lectores, $cola_lectores, $cola_escritores  ) );
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
                $log_archivo->close_file();
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
