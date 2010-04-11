package Test::Smoke::Metabase;

use strict;
use warnings;

our $VERSION = "0.03";

use base "Metabase::Report";
__PACKAGE__->load_fact_classes;

use Carp;
use Test::Smoke::Metabase::Transport;

sub report_spec
{
    return {
	"Test::Smoke::Fact::SmokeID"		=> 1,
	"Test::Smoke::Fact::TestEnvironment"	=> "0+",
	"Test::Smoke::Fact::SmokeConfig"	=> 1,
	"Test::Smoke::Fact::TestResult"		=> "0+",
	};
    } # report_spec

sub send
{
    my ($self, $dest) = @_;

    ref $dest eq "HASH" && exists $dest->{uri} && exists $dest->{id_file} or
	croak ("usage: \$report->send ({ uri => '...', id_file => '...')");

    my $transport = Test::Smoke::Metabase::Transport->new (
	transport	=> "Metabase",
	transport_args	=> [
	    uri		=> $dest->{uri},
	    id_file	=> $dest->{id_file},
	    ],
	);
    $transport->send ($self);
    } # send

1;

__END__

=head1 NAME

Test::Smoke::Metabase - Test::Smoke Metabase interface object

=head1 SYNOPSIS

  my $report = Test::Smoke::Metabase->open (
      resource => "http://perl5.git.perl.org/perl.git/8c576062",
      );

  $report->add (Test::Smoke::Fact::SmokeID => {
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
      });

  $report->add (Test::Smoke::Fact::TestEnvironment => {
      PERL5LIB     => $ENV{PERL5LIB},
      LC_ALL       => $ENV{LC_ALL},
      LANG         => $ENV{LANG},
      });

  $report->add (Test::Smoke::Fact::SmokeConfig =>
      "-Duse64bitall -DDEBUGGING"
      );

  $report->add (Test::Smoke::Fact::TestResult => {
      io_env       => "perlio",
      output       => $output,
      summary      => "F",
      });

  $report->close ();

  $report->send ({
      uri          => "http://metabase.example.com:3000/",
      id_file      => "/home/tux/smoke/metabase_id.json",
      });

=head1 DESCRIPTION

Metabase report class encapsulating Facts about a Test::Smoke report

This describes the interface of sending Test::Smoke reports to the
CPANTESTERS-2.0 infrastructure. This interface describes what facts
are stored and how they relate to a complete report.

=head2 SmokeID

These facts identify a smoke. With this ID, one should be able to find
all other facts that belong to a single smoke run.  A more detailed
description can be found in L<Test::Smoke::Fact::SmokeID>.

=head2 TestEnvironment

This is optional. It can describe what environment variable that could
possibly influence a smoke run where set on the start of this smoke.
Not all are relevant, as Test::Smoke itself will set/reset the ones it
knows to be relevant.  A more detailed description can be found in
L<Test::Smoke::Fact::TestEnvironment>.

=head2 SmokeConfig

For each configuration smoked in a full smoke run, this describes the
configuration for the TestResult (if available).  A more detailed
description can be found in L<Test::Smoke::Fact::SmokeConfig>.

=head2 TestResult

These are the results for a finished configuration. It will hold as
much information as possible.  A more detailed description can be
found in L<Test::Smoke::Fact::TestResult>.

=begin nopod

=head2 report_spec

=end nopod

=head2 send

Will send the report using Test::Smoke::Metabase::Transport

=head1 SEE ALSO

L<Test::Smoke>, L<Test::Smoke::Fact::SmokeID>,
L<Test::Smoke::Fact::TestEnvironment>, L<Test::Smoke::Fact::SmokeConfig>,
L<Test::Smoke::Fact::TestResult>, L<Metabase::Report>, L<Metabase::Fact>.

=head1 AUTHOR

H.Merijn Brand

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2010 by H.Merijn Brand

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
