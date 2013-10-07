package Mojolicious::Plugin::MangoAPI;
use Mojo::Base 'Mojolicious::Plugin';

use Mango;
use Mango::BSON  qw/bson_oid/;
use Data::Dump qw/dump/;

our $VERSION = '0.01';

has cfg => sub { +{} };

sub register {
  	my ($p, $app, $config) = @_;

	my $auth  = ($config->{user} and $config->{pass} ? $config->{user} . ':' . $config->{pass} . '@' : '' );
	my $server_db = ($config->{server} and $config->{db} ? $config->{server} . '/' . $config->{db} : '');

 	return if !$server_db and !$config->{uri};

  	$config->{uri} = $config->{uri} ||  'mongodb://' . $auth . $server_db;
  	$config->{route} = $config->{route} || $app->routes;
  	$config->{rest_name} = $config->{rest_name} || 'mango';
  	$config->{max_connections} = $config->{max_connections} || 10;

  	$p->cfg($config);

	$app->attr( mongodb => sub { 
    	my $mango = Mango->new($p->cfg->{uri});
    	$mango->max_connections($p->cfg->{max_connections}) if $p->cfg->{max_connections};
    	$mango;
    });

	$app->helper( mango => sub { shift->app->mongodb });

	$p->cfg->{route}->add_shortcut( mango_api => sub {
		my ($r, $name) = @_;

		return unless $name;

		my $c = $app->mango->db->collection($name);
		return unless $c;

		my $mango_api = $r->route('/' . $p->cfg->{rest_name} . "/$name");

		#Create new
		$mango_api->post(sub {
			my $self = shift;
			$self->render_later;

			my $params = ($self->req->json || $self->req->params->to_hash );

			$c->insert($params => sub {
				my ($collection, $err, $oid) = @_;

				if ($err) {
					$self->render(json => {
						ok => 0,
						msg => $err
					});
				} else {
					$self->render(json => {
						ok => 1,
						oid => $oid
					});
				}
			});
		})->name("create_$name");

		#Read by current $oid
		$mango_api->get('/:oid' => sub {
			my $self = shift;
			my $oid = bson_oid( $self->stash('oid') );
			$self->render_later;

			$c->find_one($oid => sub {
 				my ($cursor, $err, $doc) = @_;

 				if ($err) {
				 	$self->render(json => {
				 		ok => 0,
				 		msg => $err
				 	});
				} else {
				 	$self->render(json => {
				 		ok => 1,
				 		data => $doc
				 	});
				}
 			});

		})->name("find_one_$name");

		# Read all from this collections
		$mango_api->get(sub {
			my $self = shift;
			$self->render_later;

			$c->find->all(sub {
				my ($cursor, $err, $docs) = @_;

				if ($err) {
			 		$self->render(json => {
				 		ok => 0,
						msg => $err
				 	});
				} else {
				 	$self->render(json => {
				 		ok => 1,
				 		data => $docs,
				 		total => scalar (@$docs)
				 	});
				}
			});
		})->name("find_$name");

		#Update by current $oid
		$mango_api->put('/:oid' => sub {
			my $self = shift;
			my $oid = bson_oid( $self->stash('oid') );
			$self->render_later;

			my $params = ( $self->req->json || $self->req->params->to_hash );

			$c->update( ($oid, $params,{single => 1}) => sub {
				my ($collection, $err, $doc) = @_;

				if ($err) {
			 		$self->render(json => {
				 		ok => 0,
						msg => $err
				 	});
				} else {
				 	$self->render(json => {
				 		ok => 1,
				 		data => $doc
				 	});
				}
			});

		})->name("update_one_$name");

		#Delete by current $oid
		$mango_api->delete('/:oid' => sub {
			my $self = shift;
			my $oid = bson_oid( $self->stash('oid') );
			$self->render_later;

			$c->remove(($oid, {single => 1}) => sub {
				my ($collection, $err, $doc) = @_;

				if ($err) {
			 		$self->render(json => {
				 		ok => 0,
						msg => $err
				 	});
				} else {
				 	$self->render(json => {
				 		ok => 1,
				 		data => $doc
				 	});
				}
			});
		})->name("remove_one_$name");

		return $mango_api;
	});

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
