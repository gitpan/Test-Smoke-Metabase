package Test::Smoke::Fact::Build;

use strict;
use warnings;

use base "Metabase::Fact::Hash";

our $VERSION = "0.010";

sub required_keys
{
    qw( summary
	);
    } # required_keys

sub optional_keys
{
    qw( TEST_JOBS
	LC_ALL
	LANG

	manifest_msgs
	compiler_msgs
	skipped_tests
	harness_only
	);
    } # optional_keys

sub validate_content
{
    my $self = shift;

    my $content = $self->content;
    $content->{summary} =~ m/^[-OFXcMmt?]$/ or $content->{summary} = "?";
    $self->SUPER::validate_content;
    } # validate_content

sub content_metadata
{
    my $self = shift;
    my $content = $self->content;

    return { map { $_ => $content->{$_} } grep { !m/_(?:msgs|tests)$/ }
	$self->required_keys, $self->optional_keys };
    } # content_metadata

sub content_metadata_types
{
    my $self = shift;

    return { map { $_ => "//str" } grep { !m/_(?:msgs|tests)$/ }
	$self->requited_keys, $self->optional_keys };
    } # content_metadata_types

1;

=head1 NAME

Test::Smoke::Fact::Build - The build environment for a Test::Smoke report

=head1 SYNOPSIS

  my $fact = Test::Smoke::Fact::Build->new (
      resource => "http://perl5.git.perl.org/perl.git/8c576062",
      content  => {
          TEST_JOBS     => $ENV{TEST_JOBS},
          LC_ALL        => $ENV{LC_ALL},
          LANG          => $ENV{LANG},
          manifest_msgs => "...",
          compiler_msgs => "...",
          skipped_tests => "-",
          harness_only  => 0,
          summary       => "F",
	  },
      );

=head1 DESCRIPTION

This fact describes the environment variables that were set when the
smoke run started that could possibly influence the run.

Not all are relevant, as Test::Smoke itself will set/reset the ones
it knows to be relevant.  

It optionally stores any messages from MANIFEST checks, the compiler
messages - if any - that were issued during the build process, the
tests that were skipped and a summary for this build.

=head2 manifest_msgs

If this build gave any MANIFEST related messages during initialization
or cleanup, they will be kept in this property.

=head2 compiler_msgs

If this build gave any compiler related messages during the build, they
will be kept in this property.

=head2 skipped_tests

If this run skipped any tests - for whatever reason - they will be
kept here.

=head2 harness_only

This item optionally indicates if the smoke ran harness_only.

=head2 summary

This item holds the summary of this build. If the build was successful
and tests were actually run, it will be the I<worst> summary of any of 
the tests ran. Otherwise it will reflect the reason why the build did
not succeed, or tests could not start. See L<Test::Smoke> for the possible
values.

=head1 BUGS

=head1 SEE ALSO

L<Test::Smoke>, L<Test::Smoke::Metabase>, L<Metabase::Fact>.
L<Metabase::Fact::Hash>.

=head1 AUTHOR

H.Merijn Brand

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2010-2011 by H.Merijn Brand

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
