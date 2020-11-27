#!/usr/bin/perl

package Escritor;

use strict;
use warnings;

=pod
Representa un proceso Escritor generalizado a partir del paquete Proceso
=cut
our @ISA = qw(Proceso);    # inherits from Proceso

sub new {
    my ($class) = @_;
    my $self = $class->SUPER::new( $_[1], $_[2], $_[3], $_[4], $_[5] );

    bless $self, $class;

    return $self
}

=pod
Ejecuta comportamiento de proceso
=cut
sub ejecutar() {
    my ( $self, $dba ) = @_;
    $dba->grabar_db($self->{_cantidad});
}

1;
