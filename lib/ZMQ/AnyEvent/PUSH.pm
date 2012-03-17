package ZMQ::AnyEvent::PUSH;
# ABSTRACT: Asynchronously serviced ZeroMQ PUSH Socket

use AnyEvent;
use Moose;
use ZeroMQ::Constants qw{:socket};
use namespace::autoclean;

extends 'ZMQ::AnyEvent';
with 'ZMQ::AnyEvent::Role::Sender';

sub _build_type {ZMQ_PUSH};

=for Pod::Coverage BUILD

=cut

sub BUILD {
    my ($self) = @_;
    $self->socket->bind ($self->endpoint);
}

=attr endpoint

The endpoint attribute must be given a string representing the ZeroMQ
socket to work with.

=method send

The send method takes a list of items, packages them up as a
(potentially multi-part) message, and sends them off through the
socket.  It returns false in the event of an error.

=cut

1;
