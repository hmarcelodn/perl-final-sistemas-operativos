#!/usr/bin/perl

package semaforos;

use FindBin qw( $RealBin );
use lib "$RealBin/../src/modules";

# Modulos de Perl
use strict;
use warnings;

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
use Semaforo;

my $mutex_1 = Semaforo->new('mutex_1', 1);


$mutex_1->down();



$mutex_1->up();
