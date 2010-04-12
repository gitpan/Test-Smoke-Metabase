#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 6;
use Test::Smoke::Metabase;

ok (my $report = Test::Smoke::Metabase->open (
    resource     => "perl:///commit/8c576062",
    ), "Initiate report");

ok ($report->add ("Test::Smoke::Fact::SmokeID" => {
    git_id       => "8c57606294f48eb065dff03f7ffefc1e4e2cdce4",
    perl_id      => "5.12.2-RC4",
    hostname     => "smokebox",
    architecture => "pa_risc-2.0",
    osname       => "HP-UX",
    osversion    => "11.31",
    cc           => "cc",
    ccversion    => "B3910B",
    parallel     => 1,
    user         => "tux",
    smoke_date   => "20100528",
    }), "Add SmokeID");

ok ($report->add ("Test::Smoke::Fact::TestEnvironment" => {
    PERL5LIB     => $ENV{PERL5LIB},
    LC_ALL       => $ENV{LC_ALL},
    LANG         => $ENV{LANG},
    }), "Add TestEnvironment");

ok ($report->add ("Test::Smoke::Fact::SmokeConfig" =>
    "-Duse64bitall -DDEBUGGING"
    ), "Add SmokeConfig");

my $output = "Empty report";

ok ($report->add ("Test::Smoke::Fact::TestResult" => {
    io_env       => "perlio",
    output       => $output,
    summary      => "F",
    }), "Add TestResult");

ok ($report->close (), "Close");
