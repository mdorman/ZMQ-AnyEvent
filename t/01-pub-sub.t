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
my $pub = ZMQ::AE::PUB ($endpoint);
my $sub = ZMQ::AE::SUB ($endpoint, ['banana'], sub {
                            my ($topic, $message) = @_;
                            $cv->send ($message);
                        });
AE::postpone {$pub->send ('banana', 'phone')};
is $cv->recv, 'phone', "Testing we got our message back";

done_testing;
