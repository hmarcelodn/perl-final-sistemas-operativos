#!/usr/bin/perl

package main;

use lib '/Users/admin/Desktop/Projects/perl-final-sistemas-operativos/src/modules';

use strict;
use warnings;

use Planificador;
use Cola;
use Proceso;

# Colas de corto plazo
# my $cola_listos = Cola->new();
# my $cola_ejecutando = Cola->new();
# my $cola_bloqueados = Cola->new();

# Colas de largo plazo
my $cola_nuevos = Cola->new();
# my $cola_salida = Cola->new();

# Planificador
my $planificador = Planificador->new();

my $ciclos = 0;

# CPU Ciclos
# while(1) {
#     printf "Ciclo # $ciclos \n";

    print $cola_nuevos->contar()."\n";
    $cola_nuevos->encolar( Proceso->new(1,2) );
    $cola_nuevos->encolar( Proceso->new(3,4) );
    print $cola_nuevos->contar()."\n";

#     $ciclos = $ciclos + 1;
# }

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

