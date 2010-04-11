package Test::Smoke::Fact::TestResult;

use strict;
use warnings;

use base "Metabase::Fact::Hash";

our $VERSION = "0.003";

sub required_keys
{
    qw( io_env
	output
	summary
	);
    } # required_keys

# Optional future validation:
# io_env: "", "stdio", "perlio", "lang"
# output: non-empty
# summary: "O", "F", "X", "c", "M", "m", "t", "-"

sub content_metadata
{
    my $self = shift;
    my $content = $self->content;

    return {
	io_env	=> $content->{io_env},
	output	=> $content->{output},
	summary	=> $content->{summary},
	};
    } # content_metadata

sub content_metadata_types
{
    return {
	io_env	=> "//str",
	output	=> "//str",
	summary	=> "//str",
	};
    } # content_metadata_types

1;

__END__

=head1 NAME

Test::Smoke::Fact::TestResult - The output for a Test::Smoke report

=head1 SYNOPSIS

  my $fact = Test::Smoke::Fact::TestOutput->new (
      resource => "http://perl5.git.perl.org/perl.git/8c576062",
      content  => {
          io_env  => "perlio",
          summary => "F",
          output  => $output,
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
are "O", "F", "X", "c", "M", "m", "-", and "?". They are documented
in Test::Smoke.

=item output

This is the complete output caught during a smoke test run.

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
