package ZMQ::AnyEvent::SUB;
# ABSTRACT: Asynchronously serviced ZeroMQ SUB Socket

use AnyEvent;
use Moose;
use ZeroMQ::Constants qw{:socket};
use namespace::autoclean;

extends 'ZMQ::AnyEvent';
with 'ZMQ::AnyEvent::Role::Receiver';

has topics => (default => sub {[]},
               handles => {list_topics => 'elements'},
               is => 'ro',
               isa => 'ArrayRef',
               required => 1,
               traits => ['Array']);

sub _build_type {ZMQ_SUB};

=for Pod::Coverage BUILD

=cut

sub BUILD {
    my ($self) = @_;
    map {
        $self->subscribe ($_)
    } $self->list_topics;
    AE::log trace => "Connecting socket to %s", $self->endpoint;
    $self->socket->connect ($self->endpoint);
}

=attr endpoint

The endpoint attribute must be given a string representing the ZeroMQ
socket to work with.

=attr on_read

The on_read attribute must be given a coderef that will be called
whenever a new message is received.  If the callback returns a result,
that will be sent as a reply to the sender.

=method subscribe

Subscribe the socket to the given topic.  These subscriptions use pure
prefix matching, so you have to keep it simple.

=cut

sub subscribe {
    my ($self, $topic) = @_;
    AE::log trace => "Subscribing socket to %s", $_;
    $self->socket->setsockopt (ZMQ_SUBSCRIBE, $topic);
}

=method unsubscribe

Unsubscribe the socket to the given topic.

=cut

sub unsubscribe {
    my ($self, $topic) = @_;
    AE::log trace => "Unsubscribing socket from %s", $_;
    $self->socket->setsockopt (ZMQ_UNSUBSCRIBE, $topic);
}

1;
