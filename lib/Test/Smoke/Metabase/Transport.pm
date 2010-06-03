#!/usr/bin/perl

use warnings;
use strict;

package Test::Smoke::Metabase::Transport;

our $VERSION = "0.01";

#use base 'Test::Reporter::Transport';

use Carp ();
use JSON ();
use Metabase::User::Profile ();
use Metabase::User::Secret ();
use Metabase::Client::Simple ();

BEGIN {
    Metabase::User::Profile->load_fact_classes;
    }

my @allowed_args  = qw( uri id_file client );
my @required_args = qw( uri id_file );

sub new
{
    my $class = shift;
    @_ % 2 and
	Carp::confess __PACKAGE__ . " requires transport args in key/value pairs\n";

    my %args = (
	client => "Metabase::Client::Simple",
	@_,
	);

    for my $k (@required_args) {
	exists $args{$k} or
	    Carp::confess __PACKAGE__ . " requires $k argument\n"
	}

    for my $k (keys %args) {
	grep { $k eq $_ } @allowed_args or
	    Carp::confess __PACKAGE__ . " unknown argument '$k'\n"
	}

    return bless \%args => $class;
    } # new

# Local cache
my %id_file;
my %clients;

sub send
{
    my ($self, $report) = @_; # $report should be a Test::Smoke::Metabase obj

    my $id_file = $self->{id_file};
    $id_file{$id_file} ||= [ $self->_load_id_file ];
    my ($profile, $secret) = @{$id_file{$id_file}};

    # Load specified metabase client.
    my $class = $self->{client};
    eval "require $class" or
	Carp::confess __PACKAGE__ . ": could not load client '$class':\n$@\n";

    my $uri = $self->{uri};
    $clients{$id_file}{$uri} ||= $class->new (
	uri     => $uri,
	profile => $profile,
	secret  => $secret,
	);
    my $client = $clients{$id_file}{$uri};

    return $client->submit_fact ($report);
    } # send

sub _load_id_file
{
    my ($self) = shift;

    open my $fh, "<", $self->{id_file} or
	Carp::confess __PACKAGE__ . ": could not read ID file '$self->{id_file}'" . "\n$!";

    my $data = JSON->new->ascii->decode (do { local $/; <$fh> });

    my $profile = eval { Metabase::User::Profile->from_struct ($data->[0]) } or
	Carp::confess __PACKAGE__ . ": could not load Metabase profile\n" .
				    "from '$self->{id_file}':\n$@";

    my $secret  = eval { Metabase::User::Secret->from_struct ($data->[1])  } or
	Carp::confess __PACKAGE__ . ": could not load Metabase secret\n" .
				    "from '$self->{id_file}':\n $@";

    return ($profile, $secret);
    } # _load_id_file

1;

=pod

=head1 NAME

Test::Smoke::Metabase::Transport - Metabase transport for Test::Smoke::Metabase

=head1 SYNOPSIS

    my $report = Test::Reporter->new (
        transport      => "Metabase",
        transport_args => [
            uri     => 'http://metabase.example.com:3000/',
            id_file => '/home/jdoe/.metabase/metabase_id.json',
            ],
        );

    # use space-separated in a Test::Smoke metabase.ini
    transport = Metabase uri http://metabase.example.com:3000/ ...

=head1 DESCRIPTION

This module submits a Test::Smoke::Metabase report to the specified Metabase
instance.

This requires a network connection to the Metabase uri provided.  If you wish
to save reports during offline operation, see L<Test::Reporter::Transport::File>.

=head1 USAGE

See L<Test::Reporter> and L<Test::Reporter::Transport> for general usage
information.

=head2 Transport arguments

Unlike most other Transport classes, this class requires transport arguments
to be provided as key-value pairs:

    my $report = Test::Reporter->new (
        transport      => "Metabase",
        transport_args => [
            uri     => 'http://metabase.example.com:3000/',
            id_file => '/home/jdoe/.metabase/metabase_id.json',
            ],
        );

Arguments include:

=over

=item C<uri> (required)

The C<uri> argument gives the network location of a Metabase instance to
receive reports.

=item C<id_file> (required)

The C<id_file> argument must be a path to a Metabase ID file. If you do
not already have an ID file, use the L<metabase-profile> program to
create one.

  $ metabase-profile

This creates the file F<metabase_id.json> in the current directory.  You
can also give an C<--output> argument to save the file to a different
location or with a different name.

=back

=head1 METHODS

These methods are only for internal use by Test::Smoke::Metabase.

=head2 new

    my $sender = Test::Reporter::Transport::File->new ($params);

The C<new> method is the object constructor.

=head2 send

    $sender->send ($report);

The C<send> method transmits the report.

=head1 AUTHORS

  H.Merijn Brand <h.m.brand@xs4all.nl>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2010 by H.Merijn Brand

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
