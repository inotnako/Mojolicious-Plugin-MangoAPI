use Mojo::Base -strict;

use Test::More;
use Mojolicious::Lite;
use Test::Mojo;
use Time::Piece;

use Mojo::IOLoop;

use lib 'lib';

my $test_co = 'test';
my $text_test = 'testAloxa when time => ' . localtime->hms;
my $test_oid = $ENV{TEST_OID};


get '/' => sub {
  my $self = shift;
  $self->render(text => 'Hello Mojo!');
};

my $t = Test::Mojo->new;
$t->get_ok('/')->status_is(200)->content_is('Hello Mojo!');

my $app = $t->app;
my $r = $app->routes;

$app->plugin('MangoAPI',{
	uri => $ENV{TEST_URI},
	route => $r
});


$r->mango_api($test_co);

$t->post_ok("/mango/$test_co" => {DNT => 1} => json => { a => $text_test . ' => for A.', b => $text_test . ' => for B.' } )
	->status_is(200)
	->json_has({ok => 1}, 'right content');

$t->get_ok("/mango/$test_co")
	->status_is(200)
	->json_has({ok => 1}, 'right content');

if ($test_oid) {
	$t->get_ok("/mango/$test_co/$test_oid")
		->status_is(200)
		->json_has({ok => 1}, 'right content');

	$t->put_ok("/mango/$test_co/$test_oid" => { DNT => 1} => json => { a => $text_test . ' => for Ax. Update' . localtime->hms  })
		->status_is(200)
		->json_has({ok => 1}, 'right content');

	$t->delete_ok("/mango/$test_co/$test_oid")
		->status_is(200)
		->json_has({ok => 1}, 'right content');
}

# $t->get_ok("/mango/$test_co")
# 	->status_is(200)
# 	->json_has({ok => 1}, 'right content');

done_testing();
