use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Mojolicious::Plugin::MangoAPI',
  VERSION_FROM => 'lib/Mojolicious/Plugin/MangoAPI.pm',
  AUTHOR       => 'Anton Konovalov <nospam@cpan.org>',
  PREREQ_PM    => {'Mojolicious' => '4.45', 'Mango' => '0.14'}
  # test         => {TESTS => 't/*.t'}
);
