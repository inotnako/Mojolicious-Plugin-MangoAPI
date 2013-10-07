package Mojolicious::Plugin::MangoAPI;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.01';

sub register {
  my ($self, $app) = @_;
}

1;
__END__

=encoding utf8

=head1 NAME

Mojolicious::Plugin::MangoAPI - Mojolicious Plugin

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('MangoAPI');

  # Mojolicious::Lite
  plugin 'MangoAPI';

=head1 DESCRIPTION

L<Mojolicious::Plugin::MangoAPI> is a L<Mojolicious> plugin.

=head1 METHODS

L<Mojolicious::Plugin::MangoAPI> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut
