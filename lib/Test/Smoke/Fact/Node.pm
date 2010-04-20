package Test::Smoke::Fact::Node;

use strict;
use warnings;

use base "Metabase::Fact::Hash";

our $VERSION = "0.010";

sub required_keys
{
    qw( hostname
	architecture
	osname
	osversion
	cc
	ccversion
	);
    } # required_keys

sub optional_keys
{
    qw( user
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

Test::Smoke::Fact::SmokeID - The run environment for a Test::Smoke report

=head1 SYNOPSIS

  my $fact = Test::Smoke::Fact::SmokeID->new (
      resource => "http://perl5.git.perl.org/perl.git/8c576062",
      content  => {
	  perl_id      => "5.12.2-RC4",
	  hostname     => "smokebox",
	  architecture => "PA-RISC2.0/64/2 cpu",
	  osname       => "HP-UX",
	  osversion    => "11.31",
	  cc           => "cc",
	  ccversion    => "B3910B",
	  parallel     => 1,
	  user         => "tux",
	  smoke_date   => "2010-05-28 12:13:14 +01",
	  },
      );

=head1 DESCRIPTION

These facts identify a smoke. With this ID, one should be able to
find all other facts that belong to a single smoke run.

=over 4

=item git_id

This item describes the long form of the git SHA1 hash id of the perl
checkout that is being smoked.

 e.g. "8c57606294f48eb065dff03f7ffefc1e4e2cdce4"

=item perl_id

This item describes the perl version (or tag) of the perl checkout that
is being smoked.

 e.g. "5.12.2-RC4"

=item hostname

This item describes the host name of the machine on which the smoke runs.

 e.g. "smokebox"

=item architecture

This item describes, as completely as possible, the architecture of the
system on which the smoke runs.

 e.g. "PA-RISC2.0/64/2 cpu"

This information is an aggregation of what Test::Smoke was able to gather,
in above example, a PA-RISC 2.0 64bit architecture with 2 CPU's. The format
of this information in not normalized across architectures, it just joins
all information found.

=item osname

This item describes the Operating system name, which is not guaranteed to
be the same as C<$^O>.

 e.g. "HP-UX"

=item osversion

This item describes the operating system version.

 e.g. "11.31"

=item cc

This item describes the name of the C-compiler used for this smoke. It
does not tell anything about the identity of the compiler.

 e.g. "cc"

=item ccversion

This item describes the version of the C-compiler

 e.g. "B3910B"

=item parallel

This item (a boolean) indicates that the core tests are run in parallel.
This was done by passing some C<-j#> option to C<Test::Harness>.

=item user

This item describes the name of the I<user> who ran the smoke.

 e.g. "tux"

=item smoke_date

This item describes the date (and time), preferably in ISO norm.

 e.g. "2010-05-28T12:13:14+01"

=item smoke_id

This item should be a MD5 hash of the above items, but it is possible to
pass one. Unless one is passed, it is automatically generated.

=item applied_patches

This optional item describes what additional patches have been applied
before the smoke started.

=item manifest_msgs

If there are warnings regarding the MANIFEST, this optional item will
store them.

=item skipped_tests

If tests are generally skipped for this smoke, this optional item will
reflect the list of skipped tests.

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
