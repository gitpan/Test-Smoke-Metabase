#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 9;
use Test::Smoke::Metabase;

ok (my $report = Test::Smoke::Metabase->open (
    resource     => "perl:///commit/8c576062",
    ), "Initiate report");

ok ($report->add ("Test::Smoke::Fact::SmokeID" => {
    smoke_date      => "20100528",
    perl_id         => "5.12.2-RC4",
    git_id          => "8c57606294f48eb065dff03f7ffefc1e4e2cdce4",
    applied_patches => "-",
    }), "Add SmokeID");

ok ($report->add ("Test::Smoke::Fact::Node" => {
    hostname        => "smokebox",
    architecture    => "pa_risc-2.0",
    osname          => "HP-UX",
    osversion       => "11.31",
    cc              => "cc",
    ccversion       => "B3910B",
    user            => "tux",
    }), "Add Node");

ok ($report->add ("Test::Smoke::Fact::Build" => {
    TEST_JOBS       => $ENV{TEST_JOBS},
    LC_ALL          => $ENV{LC_ALL},
    LANG            => $ENV{LANG},
    manifest_msgs   => "...",
    compiler_msgs   => "...",
    skipped_tests   => "",
    harness_only    => 0,
    summary         => "F",
    }), "Add Build");

ok ($report->add ("Test::Smoke::Fact::Config" => {
    arguments       => "-Duse64bitall -DDEBUGGING",
    parallel        => 1,
    }), "Add Config");

foreach my $io (qw( stdio perlio locale )) {
    ok ($report->add ("Test::Smoke::Fact::Result" => {
	io_env          => $io,
	output          => "",
	summary         => "F",
	locale		=> $io eq "locale" ? "en_US.utf8" : "-",
	statistics      => "Files=1802, Tests=349808, 228 wallclock secs (43.03 usr 11.80 sys + ...",
	}), "Add Result ($io)");
    }

ok ($report->close (), "Close");
