package ZMQ::AnyEvent::Role::Sender;
# ABSTRACT: Mix-in for sockets that can send (ignore)

use AnyEvent;
use Moose::Role;
use ZeroMQ::Constants qw{:socket};
use namespace::autoclean;

=for Pod::Coverage send

=cut

sub send {
    my ($self, @parts) = @_;
    my $final = pop @parts;
    for my $part (@parts) {
        AE::log trace => "Sending part %s", $part;
        $self->socket->send ($part, ZMQ_SNDMORE);
    }
    AE::log trace => "Final part is %s", $final;
    $self->socket->send ($final) == 0
}

1;
