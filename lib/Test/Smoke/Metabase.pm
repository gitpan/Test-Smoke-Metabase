package Test::Smoke::Metabase;

use strict;
use warnings;

our $VERSION = "0.22";

use base "Metabase::Report";
__PACKAGE__->load_fact_classes;

use Carp;
use Test::Smoke::Metabase::Transport;

sub report_spec
{
    return {
	"Test::Smoke::Fact::SmokeID"	=> 1,
	"Test::Smoke::Fact::Node"	=> 1,
	"Test::Smoke::Fact::Build"	=> 1,
	"Test::Smoke::Fact::Config"	=> 1,
	"Test::Smoke::Fact::Result"	=> "0+",
	};
    } # report_spec

sub send
{
    my ($self, $dest) = @_;

    ref $dest eq "HASH" && exists $dest->{uri} && exists $dest->{id_file} or
	croak ("usage: \$report->send ({ uri => '...', id_file => '...')");

    my $transport = Test::Smoke::Metabase::Transport->new (
	uri	=> $dest->{uri},
	id_file	=> $dest->{id_file},
	);
    $transport->send ($self);
    } # send

1;

__END__

=head1 NAME

Test::Smoke::Metabase - Test::Smoke Metabase interface object

=head1 SYNOPSIS

  my $report = Test::Smoke::Metabase->open (
      resource        => "perl:///commit/8c57606294f48eb065dff03f7ffefc1e4e2cdce4",
      );

  $report->add ("Test::Smoke::Fact::SmokeID" => {
      smoke_date      => "2011-04-17 13:41:14 +01",
      git_id          => "1f656fcf060e343780f7a91a2ce567e8a9de9414",
      perl_id         => "5.14.0",
      git_describe    => "5.13.11-452-g1f656fc",
      applied_patches => "-",
      });

  $report->add ("Test::Smoke::Fact::Node" => {
      hostname        => "smokebox",
      architecture    => "ia64",
      osname          => "HP-UX",
      osversion       => "B.11.31/64",
      cpu_count       => 2,
      cpu_description => "Itanium 2 9100/1710",
      cc              => "cc",
      ccversion       => "B3910B",
      user            => "tux",
      });

  $report->add ("Test::Smoke::Fact::Build" => {
      TEST_JOBS       => $ENV{TEST_JOBS},
      LC_ALL          => $ENV{LC_ALL},
      LANG            => $ENV{LANG},
      manifest_msgs   => "...",
      compiler_msgs   => "...",
      skipped_tests   => "-",
      harness_only    => 0,
      summary         => "F",
      });

  $report->add ("Test::Smoke::Fact::Config" => {
      arguments       => "-Duse64bitall -DDEBUGGING",
      parallel        => 1,
      debugging       => 1,
      });

  $report->add ("Test::Smoke::Fact::Result" => {
      io_env          => "perlio",
      output          => "...",
      summary         => "F",
      statistics      => "Files=1802, Tests=349808, 228 wallcl...",
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

This fact identify what is smoked. Together with the C<Node> it
identifies what I<Fact>'s belong together in a complete L<Test::Smoke>
run.  A more detailed description can be found in
L<Test::Smoke::Fact::SmokeID>.

=head2 Node

This fact identifies where the smoke is executed. Together with the
C<SmokeID> it identifies what I<Fact>'s belong together in a complete
L<Test::Smoke> run.  A more detailed description can be found in
L<Test::Smoke::Fact::Node>.

=head2 Build

This fast describes how a L<Test::Smoke> is built, it holds the overall
information regarding how the smoke was started and generic information
about a single build attempt. A more detailed description can be found
in L<Test::Smoke::Fact::Build>.

=head2 Config

This fact describes the arguments that were used for this smoke build.
For each configuration smoked in a full smoke run, this describes the
configuration for the C<Result>'s (if available).  A more detailed
description can be found in L<Test::Smoke::Fact::Config>.

Note that the C<parallel> attribute logically would fit better in the
C<Build> Fact, but that it is stored in C<Config> Fact for indexing
(and searching) purposes.

=head2 Result

These are the results for a finished test run. It will hold as much
information as possible. Up to three C<Result> Facts can be found
inside the Report. A more detailed description can be found in
L<Test::Smoke::Fact::Result>.

=begin nopod

=head2 report_spec

=end nopod

=head2 send

Will send the report using Test::Smoke::Metabase::Transport

=head1 SEE ALSO

L<Test::Smoke>, L<Test::Smoke::Fact::SmokeID>, L<Test::Smoke::Fact::Node>,
L<Test::Smoke::Fact::Build>, L<Test::Smoke::Fact::Config>,
L<Test::Smoke::Fact::Result>, L<Metabase::Report>, L<Metabase::Fact>.

=head1 AUTHOR

H.Merijn Brand

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2010-2011 by H.Merijn Brand

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
