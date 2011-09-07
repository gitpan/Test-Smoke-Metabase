#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 9;
use Test::Smoke::Metabase;

ok (my $report = Test::Smoke::Metabase->open (
    resource     => "perl:///commit/8c576062",
    ), "Initiate report");

ok ($report->add ("Test::Smoke::Fact::SmokeID" => {
    smoke_date      => "2011-04-17 13:41:14",
    git_id          => "1f656fcf060e343780f7a91a2ce567e8a9de9414",
    git_describe    => "5.13.11-452-g1f656fc",
    perl_id         => "5.14.0",
    applied_patches => "-",
    }), "Add SmokeID");

ok ($report->add ("Test::Smoke::Fact::Node" => {
    hostname        => "smokebox",
    architecture    => "ia64",
    osname          => "HP-UX",
    osversion       => "B.11.31/64",
    cpu_count       => 2,
    cpu_description => "Itanium 2 9100/1710",
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
    debugging       => 1,
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
