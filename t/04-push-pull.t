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
my $push = ZMQ::AE::PUSH ($endpoint);
my $pull = ZMQ::AE::PULL ($endpoint, sub {$cv->send (@_)});
AE::postpone {$push->send ('banana', 'phone')};
is $cv->recv, 'banana', "Testing we got the message for the topic";

done_testing;
