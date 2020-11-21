#!/usr/bin/perl

package Cola;

sub new {
    my $class = shift;

    my $self = {
        @_items = (),
    };

    bless $self, $class;

    return $self
}

sub contar() {
    my ( $self ) = @_;
}

sub encolar() {
    my ( $self ) = @_;
    push($self->_items, "item");
}

sub desencolar() {
    my ( $self ) = @_;
    return shift($self->_items);
}

1;
