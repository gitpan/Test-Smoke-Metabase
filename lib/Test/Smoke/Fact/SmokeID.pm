package Test::Smoke::Fact::SmokeID;

use strict;
use warnings;

use base "Metabase::Fact::Hash";

our $VERSION = "0.010";
$VERSION = eval $VERSION; ## no critic

sub required_keys
{
    qw( smoke_date
	perl_id
	git_id
	applied_patches
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
    $self->SUPER::validate_content;
    } # validate_content

sub content_metadata
{
    my $self = shift;
    my $content = $self->content;

    return { map { $_ => $content->{$_} } grep { !m/patches/ }
	$self->required_keys, $self->optional_keys };
    } # content_metadata

sub content_metadata_types
{
    my $self = shift;

    return { map { $_ => "//str" } grep { !m/patches/ }
	$self->required_keys, $self->optional_keys };
    } # content_metadata_types

1;

__END__

=head1 NAME

Test::Smoke::Fact::SmokeID - The run environment for a Test::Smoke report

=head1 SYNOPSIS

  my $fact = Test::Smoke::Fact::SmokeID->new (
      resource => "http://perl5.git.perl.org/perl.git/8c576062",
      content  => {
	  smoke_date      => "2010-05-28 12:13:14 +01",
          git_id          => "8c57606294f48eb065dff03f7ffefc1e4e2cdce4",
	  perl_id         => "5.12.2-RC4",
	  applied_patches => "-",
	  },
      );

=head1 DESCRIPTION

These facts identify a smoke. With this ID, one should be able to
find all other facts that belong to a single smoke run.

=head2 smoke_date

This item describes the date (and time), preferably in ISO norm.

 e.g. "2010-05-28T12:13:14+01"

=head2 git_id

This item describes the long form of the git SHA1 hash id of the perl
checkout that is being smoked.

 e.g. "8c57606294f48eb065dff03f7ffefc1e4e2cdce4"

=head2 perl_id

This item describes the perl version (or tag) of the perl checkout that
is being smoked.

 e.g. "5.12.2-RC4"

=head2 smoke_id

This item should be a MD5 hash of the above items, but it is possible to
pass one. Unless one is passed, it is automatically generated.

=head2 applied_patches

This optional item describes what additional patches have been applied
before the smoke started.

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
