#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

# Work around buffering that can show diags out of order
$ENV{TEST_VERBOSE} and Test::More->builder->failure_output (*STDOUT);

my @classes = qw (
    Test::Smoke::Metabase
    Test::Smoke::Fact::SmokeID
    Test::Smoke::Fact::Node
    Test::Smoke::Fact::Build
    Test::Smoke::Fact::Config
    Test::Smoke::Fact::Result
    );

plan tests => scalar @classes;

require_ok ($_) for @classes;
