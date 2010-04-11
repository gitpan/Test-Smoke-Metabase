package Test::Smoke::Fact::TestEnvironment;

use strict;
use warnings;

use base "Metabase::Fact::Hash";

our $VERSION = "0.002";

sub optional_keys
{
    qw( PERL5LIB
	TEST_JOBS
	LC_ALL
	LANG
	);
    } # optional_keys

1;

=head1 NAME

Test::Smoke::Fact::TestEnvironment - The environment for a Test::Smoke report

=head1 SYNOPSIS

  my $fact = Test::Smoke::Fact::SmokeConfig->new (
      resource => "http://perl5.git.perl.org/perl.git/8c576062",
      content  => {
          PERL5LIB	=> $ENV{PERL5LIB},
          LC_ALL	=> $ENV{LC_ALL},
          LANG		=> $ENV{LANG},
	  },
      );

=head1 DESCRIPTION

This fact describes the environment variables that were set when the
smoke run started that could possibly influence the run.

Not all are relevant, as Test::Smoke itself will set/reset the ones
it knows to be relevant.  

=head1 BUGS

=head1 SEE ALSO

L<Test::Smoke>, L<Test::Smoke::Metabase>, L<Metabase::Fact>.
L<Metabase::Fact::Hash>.

=head1 AUTHOR

H.Merijn Brand

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2010 by H.Merijn Brand

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
