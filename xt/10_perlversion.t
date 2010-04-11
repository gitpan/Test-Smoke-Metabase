#!/pro/bin/perl

use strict;
use warnings;

use Test::More;
eval "use Test::MinimumVersion";
if ($@) {
    print "1..0 # Test::MinimumVersion required for compatability tests\n";
    exit 0;
    }

all_minimum_version_ok ("5.6.0");
