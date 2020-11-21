package Planificador;

sub new {
    my $class = shift;
    my $self = {
      _inicio => shift,
      _final  => shift,
    };

    bless $self, $class;
    return $self;
}