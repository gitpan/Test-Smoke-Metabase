#!/usr/bin/perl

# Copyright 2010-2010 H.Merijn Brand

require 5.006; # <- also see postamble at the bottom for META.yml
use strict;

use ExtUtils::MakeMaker;

my %wm = (
    NAME           => "Test::Smoke::Metabase",
    ABSTRACT       => "Metabase interface for Test::Smoke",
    AUTHOR         => "H.Merijn Brand <h.merijn\@xs4all.nl>",
    VERSION_FROM   => "lib/Test/Smoke/Metabase.pm",
    PREREQ_PM	   => { "base"                     => 2.14,
			"Carp"                     => 0,
			"Digest::MD5"              => 0,
			"JSON"                     => 2,
			"Metabase::Client::Simple" => 0.006,
			"Metabase::Fact"           => 0.012,
			},
    BUILD_REQUIRES => { "Test::More"               => 0,
			},
    );
$ExtUtils::MakeMaker::VERSION > 6.30 and $wm{LICENSE} = "perl";

my $rv = WriteMakefile (%wm);

1;

package MY;

sub postamble
{
    my $min_vsn = ($] >= 5.010 && -d "xt" && ($ENV{AUTOMATED_TESTING} || 0) != 1)
	? join "\n" =>
	    'test ::',
	    '	-@env TEST_FILES="xt/*.t" make -e test_dynamic',
	    ''
	: "";
    join "\n" =>
	'cover test_cover:',
	'	ccache -C',
	'	cover -test',
	'',
	'leaktest:',
	q{	sandbox/leaktest $(FULLPERLRUN) "test_harness($(TEST_VERBOSE), '$(INST_LIB)', '$(INST_ARCHLIB)')" $(TEST_FILES)},
	'',
	'checkmeta:',
	'	perl sandbox/genMETA.pl -c',
	'',
	'fixmeta:	distmeta',
	'	perl sandbox/genMETA.pl',
	'',
	'tgzdist:	checkmeta fixmeta $(DISTVNAME).tar.gz distcheck',
	'	-@mv -f $(DISTVNAME).tar.gz $(DISTVNAME).tgz',
	'	-@cpants_lint.pl $(DISTVNAME).tgz',
	'	-@rm -f Debian_CPANTS.txt',
	'',
	$min_vsn;
    } # postamble

1;
