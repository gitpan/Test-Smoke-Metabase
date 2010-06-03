package Test::Smoke::Fact::Result;

use strict;
use warnings;

use base "Metabase::Fact::Hash";

our $VERSION = "0.010";

sub required_keys
{
    qw( io_env
	output
	summary
	);
    } # required_keys

sub optional_keys
{
    qw( statistics
	locale
	);
    } # optional_keys

# Optional future validation:
# io_env: "stdio", "perlio", "locale"
# summary: "O", "F", or "X"
#   "c", "M", "m", "t", "-" should end up in Fact::Build
sub validate_content
{
    my $self = shift;

    my $content = $self->content;
    $content->{io_env}     ||= "perlio";
    $content->{summary} =~ m/^[-OFXcMmt?]$/ or $content->{summary} = "?";
    $self->SUPER::validate_content;
    } # validate_content

sub content_metadata
{
    my $self = shift;
    my $content = $self->content;

    return { map { $_ => $content->{$_} } grep { !m/output/ }
	$self->required_keys, $self->optional_keys };
    } # content_metadata

sub content_metadata_types
{
    my $self = shift;

    return { map { $_ => "//str" } grep { !m/output/ }
	$self->required_keys, $self->optional_keys };
    } # content_metadata_types

1;

__END__

=head1 NAME

Test::Smoke::Fact::Result - The output for a Test::Smoke report

=head1 SYNOPSIS

  my $fact = Test::Smoke::Fact::TestOutput->new (
      resource => "http://perl5.git.perl.org/perl.git/8c576062",
      content  => {
          io_env     => "perlio",
          summary    => "F",
          output     => $output,
          statistics => "Files=1802, Tests=349808, 228 wallcl...",
          },
      );

=head1 DESCRIPTION

These are the results for a finished configuration. It will hold
as much information as possible.

=over 4

=item io_env

This item describes the IO environment a test run for a specific
configuration. Possible values include "stdio", "perlio" and the
description of the C<locale> in which a Unicode enabled test was
run, e.g. "nl_NL.utf8".

=item summary

This item describes the final state of the smoke. Possible values
are "O", "F", "X", "c", "M", "m", "t", "-", and "?". They are
documented in Test::Smoke.

=item output

This is the complete output caught during a smoke test run.

=item statistics

This item optionally holds the line that reflects the test run
statistics, like:

  Files=1802, Tests=349808, 228 wallclock secs ...
    (43.03 usr 11.80 sys + 269.61 cusr 38.35 csys = 362.79 CPU)

=back

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
