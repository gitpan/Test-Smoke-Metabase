package Test::Smoke::Fact::SmokeConfig;

use strict;
use warnings;

use base "Metabase::Fact::String";

our $VERSION = "0.002";

sub content_metadata
{
    my $self = shift;
    return { size => [ "//num" => length $self->content ] };
    } # content_metadata

1;

__END__

=head1 NAME

Test::Smoke::Fact::SmokeConfig - The Configuration for a Test::Smoke report

=head1 SYNOPSIS

  my $fact = Test::Smoke::Fact::SmokeConfig->new (
      resource => "http://perl5.git.perl.org/perl.git/8c576062",
      content  => "-Duse64bitall -DDEBUGGING",
      );

=head1 DESCRIPTION

This fact just shows the configuration that was smoked. It is a space separated
list of configure options.

=head1 SEE ALSO

L<Test::Smoke>, L<Test::Smoke::Metabase>, L<Metabase::Fact>.
L<Metabase::Fact::String>.

=head1 AUTHOR

H.Merijn Brand

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2010 by H.Merijn Brand

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
