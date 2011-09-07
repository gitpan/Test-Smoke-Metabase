package Test::Smoke::Fact::Config;

use strict;
use warnings;

use base "Metabase::Fact::Hash";

our $VERSION = "0.011";

sub required_keys
{
    qw( arguments
	parallel
	debugging
	);
    } # required_keys

sub optional_keys
{
    qw( 
	);
    } # optional_keys

sub validate_content
{
    my $self = shift;

    my $content = $self->content;
    $content->{arguments} ||= "[default]";
    $content->{parallel}  ||= 0;
    $content->{debugging} ||= 0;
    $self->SUPER::validate_content;
    } # validate_content

sub content_metadata
{
    my $self = shift;
    my $content = $self->content;

    return { map { $_ => $content->{$_} }
	$self->required_keys, $self->optional_keys };
    } # content_metadata

sub content_metadata_types
{
    my $self = shift;

    return { map { $_ => "//str" }
	$self->required_keys, $self->optional_keys };
    } # content_metadata_types

1;

__END__

=head1 NAME

Test::Smoke::Fact::Config - The Configuration for a Test::Smoke report

=head1 SYNOPSIS

  my $fact = Test::Smoke::Fact::Config->new (
      resource => "http://perl5.git.perl.org/perl.git/8c576062",
      content  => {
          arguments => "-Duse64bitall -DDEBUGGING",
          parallel  => 1,
          debugging => 1,
          },
      );

=head1 DESCRIPTION

This fact just shows the configuration that was smoked.

=head2 arguments

A space separated list of Configure options.

=head2 parallel

A boolean value indicating if this build was tested in parallel.
Both L<Test::Smoke>'s C<harness_options> and the environment variable
C<TEST_JOBS> can enable parallel smokes.

=head1 SEE ALSO

L<Test::Smoke>, L<Test::Smoke::Metabase>, L<Metabase::Fact>.
L<Metabase::Fact::Hash>.

=head1 AUTHOR

H.Merijn Brand

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2011 by H.Merijn Brand

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
