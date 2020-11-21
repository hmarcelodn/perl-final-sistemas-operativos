#!/usr/bin/perl

package main;

use lib '/Users/admin/Desktop/Projects/perl-final-sistemas-operativos/src/modules';

use strict;
use warnings;

use Planificador;
use Cola;
use Proceso;
use Despachador;

# Colas Planificacion de corto plazo
my $cola_listos = Cola->new();
my $cola_ejecutando = Cola->new();

# Colas Planificacion de largo plazo
my $cola_nuevos = Cola->new();
my $cola_salida = Cola->new();

# Planificador / Despachador
my $planificador = Planificador->new($cola_nuevos, $cola_listos, 0);
my $despachador = Despachador->new($cola_nuevos, $cola_listos, $cola_ejecutando, $cola_salida);

my $ciclos = 0;

# print $cola_nuevos->contar()."\n";
$cola_nuevos->encolar( Proceso->new(1,2) );
$cola_nuevos->encolar( Proceso->new(3,4) );
# print $cola_nuevos->contar()."\n";

# CPU Ciclos
while(1) {
    printf "Ciclo # $ciclos \n";

    $planificador->actualizar_ciclos($ciclos);
    $planificador->planificar();
    $despachador->despachar();

    $ciclos = $ciclos + 1;
}

# // Fran:
# // 1. Implementar DB, Implementar Escritor, Implementar Lector
# // 2. Armar semaforos
# // 3. Sincronizar todo

# // Marce:
# // 1. Implementar TDA cola
# // 2. Implementar FIFO en el planificador
# // 3. Armar el dispatcher

# // Despues:
# // 1. Lanzar procesos hardcodeados
# // 2. Agregar dinamicamente procesos
# // 3. Monitorear

