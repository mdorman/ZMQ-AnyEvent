package ZMQ::AnyEvent;
# ABSTRACT: Easy construction and use of asynchronous ZeroMQ sockets

=head1 SYNOPSIS

  use AnyEvent;
  use ZMQ::AnyEvent;

  my $cv = AE::cv;
  my $sub = zmq_ae_sub 'ipc:///var/tmp/publisher', sub { $cv->send (@_) };
  my $pub = zmq_ae_pub 'ipc:///var/tmp/publisher';
  AE::postpone {$pub->send ('sending', 'a', 'multipart', 'message')}
  print $cv->recv;

=head1 DESCRIPTION

C<ZMQ::AnyEvent> is an attempt to find the middle-ground between
C<AnyEvent::Handle::ZeroMQ>, which is a thin shim over ZeroMQ and
still makes you do a lot of work yourself (and be aware of the
vagaries of the different sockets), and C<AnyEvent::ZeroMQ> which
tries to do it all (and makes it hard for you to do things like, say,
send multipart messages).

It consists of several modules, corresponding to the different socket
type ZeroMQ offers for implementing certain patterns:

=head2 Request-Reply Pattern

=over

=item L<ZMQ::AnyEvent::REQ>

=item L<ZMQ::AnyEvent::REP>

=item L<ZMQ::AnyEvent::DEALER>

=item L<ZMQ::AnyEvent::ROUTER>

=back

=head2 Publish-Subscribe Pattern

=over

=item L<ZMQ::AnyEvent::PUB>

=item L<ZMQ::AnyEvent::SUB>

=back

=head2 Pipeline Pattern

=over

=item L<ZMQ::AnyEvent::PUSH>

=item L<ZMQ::AnyEvent::PULL>

=back

While you may directly instantiate the various C<ZMQ::AnyEvent>
subclasses directly, it's really preferred that you use the factory
functions in L<ZMQ::AE>

=cut

use AnyEvent;
use Moose;
use ZeroMQ::Context;
use ZeroMQ::Constants qw{:socket};
use ZMQ::AE;
use namespace::autoclean;

my $context;

has context => (is => 'ro',
                isa => 'ZeroMQ::Context',
                lazy_build => 1,
                required => 1);

# In the absence of a context being handed in, we will default to
# using a package variable as an effectively global context.
sub _build_context {
    AE::log trace => "Constructing context";
    $context ||= ZeroMQ::Context->new;
}

has endpoint => (is => 'ro',
                 isa => 'Str',
                 required => 1);

has socket => (is => 'ro',
               isa => 'ZeroMQ::Socket',
               lazy_build => 1,
               required => 1);

# By using a builder, subtypes can override the default for type, so
# this works everywhere.
sub _build_socket {
    my ($self) = @_;
    AE::log trace => "Building socket of type %s", $self->type;
    $self->context->socket ($self->type);
}

has type => (is => 'ro',
             isa => 'Int',
             lazy_build => 1,
             required => 1);

1;
