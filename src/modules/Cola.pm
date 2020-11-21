#!/usr/bin/perl

package Cola;

sub new {
    my $class = shift;

    my $self = {
        _items => [3],
    };

    bless $self, $class;

    return $self
}

sub contar() {
    my ( $self ) = @_;
    return scalar @{$self->{_items}};
}

sub encolar() {
    my ( $self, $item ) = @_;
    push(@{$self->{_items}}, $item);
}

# sub desencolar() {
#     my ( $self ) = @_;
#     return shift($self->_items);
# }

1;
