package ZMQ::AnyEvent::PULL;
# ABSTRACT: Asynchronously serviced ZeroMQ PULL Socket

use AnyEvent;
use Moose;
use ZeroMQ::Constants qw{:socket};
use namespace::autoclean;

extends 'ZMQ::AnyEvent';
with 'ZMQ::AnyEvent::Role::Receiver';

sub _build_type {ZMQ_PULL};

=for Pod::Coverage BUILD

=cut

sub BUILD {
    my ($self) = @_;
    $self->socket->connect ($self->endpoint);
}

=attr endpoint

The endpoint attribute must be given a string representing the ZeroMQ
socket to work with.

=attr on_read

The on_read attribute must be given a coderef that will be called
whenever a new message is received.

=cut

1;
