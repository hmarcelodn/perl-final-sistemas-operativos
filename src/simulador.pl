#!/usr/bin/perl

package main;

use lib '/Users/admin/Desktop/Projects/perl-final-sistemas-operativos/src/modules';

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

# Reloj CPU
my $ciclos = 0;

# Procesos Mock - Planificacion Largo Plazo
$cola_nuevos->encolar( Proceso->new(1,2, "P0", "NUEVO") );
$cola_nuevos->encolar( Proceso->new(3,4, "P1", "NUEVO") );

# Procesos Mock - Planificacion Corto Plazo
$cola_listos->encolar( Proceso->new(1,2, "P0", "LISTO") );
$cola_listos->encolar( Proceso->new(3,4, "P1", "LISTO") );

# CPU Ciclos
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
    sleep(3);
}
