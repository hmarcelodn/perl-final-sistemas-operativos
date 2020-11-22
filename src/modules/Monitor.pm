package Monitor;

# use strict;
use warnings;

=pod
Abstraccion que permite visualizar el estado de las colas en todo momento
=cut
sub new() {
    my $class = shift;
    my $self = {
        _nuevos => shift,
        _listos => shift,
        _ejecutando => shift,
        _salida => shift,
    };

    bless $self, $class;

    return $self;
}

=pod
Imprimir reporte de estado de colas
=cut
sub imprimir_estado_colas() {
    my ( $self ) = @_;

    my @cola_nuevos_arreglo = $self->{_nuevos}->obtener_arreglo();
    my @cola_listos_arreglo = $self->{_listos}->obtener_arreglo();


    print "---------------------------------\n";
    print "COLA: NUEVOS\n";
    print "---------------------------------\n";
    print "Proceso      Llegada     Servicio\n";
    print "---------------------------------\n";

    foreach (@cola_nuevos_arreglo) {
        my $proceso_id = $_->proceso_id();
        my $proceso_llegada = $_->llegada();
        my $proceso_servicio = $_->tiempo_servicio();
        print "$proceso_id              $proceso_llegada            $proceso_servicio \n";
    }

    print "\n";

    print "---------------------------------\n";
    print "COLA: LISTOS\n";
    print "---------------------------------\n";
    print "Proceso      Llegada     Servicio\n";
    print "---------------------------------\n";

    foreach (@cola_listos_arreglo) {
        my $proceso_id = $_->proceso_id();
        my $proceso_llegada = $_->llegada();
        my $proceso_servicio = $_->tiempo_servicio();
        print "$proceso_id              $proceso_llegada            $proceso_servicio \n";
    }
}

1;
