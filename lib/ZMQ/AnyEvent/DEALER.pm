package ZMQ::AnyEvent::DEALER;
# ABSTRACT: Asynchronously serviced ZeroMQ DEALER (AKA XREQ) Socket

use AnyEvent;
use Moose;
use ZeroMQ::Constants qw{:socket};
use namespace::autoclean;

extends 'ZMQ::AnyEvent';
with 'ZMQ::AnyEvent::Role::Receiver' => {reply => 1},
     'ZMQ::AnyEvent::Role::Sender';

sub _build_type {ZMQ_XREQ};

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

=method send

The send method takes a list of items, packages them up as a
(potentially multi-part) message, and sends them off through the
socket.  It returns false in the event of an error.

=cut

1;
