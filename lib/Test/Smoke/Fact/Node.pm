package Test::Smoke::Fact::Node;

use strict;
use warnings;

use base "Metabase::Fact::Hash";

our $VERSION = "0.011";

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
    qw( cpu_count
	cpu_description
	user
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
          hostname        => "smokebox",
          architecture    => "ia64",
          osname          => "HP-UX",
          osversion       => "B.11.31/64",
          cpu_count       => 2,
          cpu_description => "Itanium 2 9100/1710",
          cc              => "cc",
          ccversion       => "B3910B",
          user            => "tux",
          },
      );

=head1 DESCRIPTION

These facts identify a smoke. With this ID, one should be able to
find all other facts that belong to a single smoke run.

=over 4

=item hostname

This item describes the host name of the machine on which the smoke runs.

 e.g. "smokebox"

=item architecture

This item describes, as completely as possible, the architecture of the
system on which the smoke runs.

 e.g. "ia64"

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

 e.g. "B.11.31/64"

=item cc

This item describes the name of the C-compiler used for this smoke. It
does not tell anything about the identity of the compiler.

 e.g. "cc"

=item ccversion

This item describes the version of the C-compiler

 e.g. "B3910B"

=item cpu_count

This optional item describes the number of CPU's that were found for
this smoke. It does not tell how many were actually used.

 e.g. 2

=item cpu_description

This optional item describes the CPU(s) that were found for this smoke.

 e.g. "Intel(R) Core(TM) i5 CPU M 540 @ 2.53GHz (GenuineIntel 1199MHz)"

=item user

This optional item describes the name of the I<user> who ran the smoke.

 e.g. "tux"

=item smoke_id

This item should be a MD5 hash of the above items, but it is possible to
pass one. Unless one is passed, it is automatically generated.

=back

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
