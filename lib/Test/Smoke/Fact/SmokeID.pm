package Test::Smoke::Fact::SmokeID;

use strict;
use warnings;

use Digest::MD5 qw( md5_hex );

use base "Metabase::Fact::Hash";

our $VERSION = "0.002";
$VERSION = eval $VERSION; ## no critic

sub required_keys
{
    qw( git_id
	perl_id
	hostname
	architecture
	osname
	osversion
	cc
	ccversion
	parallel
	smoke_date
	);
    } # required_keys

sub optional_keys
{
    qw( smoke_id user );
    } # optional_keys

sub validate_content
{
    my $self = shift;

    $self->SUPER::validate_content;
    my $content = $self->content;
    $content->{smoke_id} or
	$content->{smoke_id} = md5_hex join "\0" => @{$content}{$self->required_keys};
    } # validate_content

sub content_metadata
{
    my $self = shift;
    my $content = $self->content;

    return {
	smoke_id	=> $content->{smoke_id},
	perl_id		=> $content->{perl_id},
	git_id		=> $content->{git_id},
	hostname	=> $content->{hostname},
	architecture	=> $content->{architecture},
	osname		=> $content->{osname},
	osversion	=> $content->{osversion},
	cc		=> $content->{cc},
	ccversion	=> $content->{ccversion},
	parallel	=> $content->{parallel},
	user		=> $content->{user},
	smoke_date	=> $content->{smoke_date},
	};
    } # content_metadata

sub content_metadata_types
{
    return {
	smoke_id	=> "//str",
	perl_id		=> "//str",
	git_id		=> "//str",
	hostname	=> "//str",
	architecture	=> "//str",
	osname		=> "//str",
	osversion	=> "//str",
	cc		=> "//str",
	ccversion	=> "//str",
	parallel	=> "//str",
	user		=> "//str",
	smoke_date	=> "//str",
	};
    } # content_metadata_types

1;

__END__

=head1 NAME

Test::Smoke::Fact::SmokeID - The run environment for a Test::Smoke report

=head1 SYNOPSIS

  my $fact = Test::Smoke::Fact::SmokeID->new (
      resource => "http://perl5.git.perl.org/perl.git/8c576062",
      content  => {
          git_id       => "8c57606294f48eb065dff03f7ffefc1e4e2cdce4",
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
