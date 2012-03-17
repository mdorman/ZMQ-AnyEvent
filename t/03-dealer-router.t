#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Test::More;
use AnyEvent::Log;
use ZMQ::AE;

$AnyEvent::Log::FILTER->level ("error");

my $endpoint = 'ipc://monkeybutt';

my $cv = AE::cv;
my $req = ZMQ::AE::DEALER ($endpoint, sub {
                               my ($topic, $message) = @_;
                               $cv->send ($message);
                           });
# We simply echo back what we're sent
my $rep = ZMQ::AE::ROUTER ($endpoint, sub { @_ });
AE::postpone {$req->send ('banana', 'phone')};
is $cv->recv, 'phone', "Testing we got the message for the topic";

done_testing;
