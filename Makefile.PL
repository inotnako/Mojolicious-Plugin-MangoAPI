use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Mojolicious::Plugin::MangoAPI',
  VERSION_FROM => 'lib/Mojolicious/Plugin/MangoAPI.pm',
  AUTHOR       => 'A Good Programmer <nospam@cpan.org>',
  PREREQ_PM    => {'Mojolicious' => '4.45'},
  test         => {TESTS => 't/*.t'}
);
