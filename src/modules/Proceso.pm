package Proceso;

sub new {
    my $class = shift;

    my $self = {
        _inicio => shift,
        _fin => shift,
    };

    bless $self, $class;

    return $self
}

1;
