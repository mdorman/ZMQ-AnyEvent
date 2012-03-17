package ZMQ::AnyEvent::Role::Receiver;
# ABSTRACT: Mix-in for sockets that can receive

use AnyEvent;
use MooseX::Role::Parameterized;
use ZeroMQ::Constants qw{:socket};
use namespace::autoclean;

parameter reply => (default => 0,
                    isa => 'Bool');

role {
    my ($p) = @_;

    has on_read => (is => 'ro',
                    isa => 'CodeRef',
                    required => 1);

    has _read_watcher => (builder => '_build__read_watcher',
                          is => 'ro',
                          isa => 'EV::IO',
                          required => 1);

    method _build__read_watcher => sub {
        my ($self) = @_;
        my $handler;
        if ($p->reply) {
            $handler = sub {
                AE::log trace => 'Activity on socket';
                while ($self->socket->getsockopt (ZMQ_EVENTS) & ZMQ_POLLIN) {
                    AE::log trace => 'Message bits pending';
                    my @parts;
                    do {
                        push @parts, $self->socket->recv->data;
                    } while ($self->socket->getsockopt (ZMQ_RCVMORE));
                    my @response = $self->on_read->(@parts);
                    $self->send (@response) if (@response);
                }
            }

        } else {
            $handler = sub {
                AE::log trace => 'Activity on socket';
                while ($self->socket->getsockopt (ZMQ_EVENTS) & ZMQ_POLLIN) {
                    AE::log trace => 'Message bits pending';
                    my @parts;
                    do {
                        push @parts, $self->socket->recv->data;
                    } while ($self->socket->getsockopt (ZMQ_RCVMORE));
                    $self->on_read->(@parts);
                }
            }
        }
        AE::io $self->socket->getsockopt (ZMQ_FD), 0, $handler;
    }
};

1;
