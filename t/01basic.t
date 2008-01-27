#perl

use strict;
use warnings;

use IO::Scalar;

use Test::More tests => 8;
BEGIN{ $ENV{MX_LOGDISPATCH_NO_DEPRECATION} = 1 } 

{
  package ConfigLogTest;

  use Moose;
  use MooseX::LogDispatch;

  with Logger(config => 'FileBased');
}

{
  package HardwiredLogTest;

  use Moose;
  use MooseX::LogDispatch;

  with Logger();

}

sub test_logger {
  my ($logger) = @_;

  $logger->debug('foo');
  $logger->info('foo');
  $logger->error('Gah!');
}

{
  my $logger = new ConfigLogTest(
    config_filename => 't/test.cfg'
  );

  isa_ok($logger->logger, 'Log::Dispatch');
  is($logger->can('error'), undef, "Object not polouted");

  tie *STDERR, 'IO::Scalar', \my $err;
  local $SIG{__DIE__} = sub { untie *STDERR; die @_ };

  test_logger($logger->logger);
  untie *STDERR;

  is($err, <<'EOF', "Got correct errors to stderr");
[info] foo at t/01basic.t line 34
[error] Gah! at t/01basic.t line 35
EOF

}

{
  my $logger = new HardwiredLogTest;
  
  isa_ok($logger->logger, 'Log::Dispatch');
  is($logger->can('error'), undef, "Object not polouted");

  tie *STDERR, 'IO::Scalar', \my $err;
  local $SIG{__DIE__} = sub { untie *STDERR; die @_ };

  test_logger($logger->logger);
  untie *STDERR;

  # Remove dates from front of lines
  $err =~ s{^\[\w+ \w+\s+\d{1,2}\s+\d\d:\d\d:\d\d \d{4}\] }{}gm;

  is($err, <<'EOF', "Got correct errors to stderr");
[debug] foo at t/01basic.t line 33
[info] foo at t/01basic.t line 34
[error] Gah! at t/01basic.t line 35
EOF

}

{
  package LevelsLogTest;

  use Moose;
  use MooseX::LogDispatch;

  with Logger(
    interface => 'Levels'
  );

}

{
  my $logger = new LevelsLogTest;
  isa_ok($logger->logger, 'Log::Dispatch');

  tie *STDERR, 'IO::Scalar', \my $err;
  local $SIG{__DIE__} = sub { untie *STDERR; die @_ };

  test_logger($logger);
  untie *STDERR;

  # Remove dates from front of lines
  $err =~ s{^\[\w+ \w+\s+\d{1,2}\s+\d\d:\d\d:\d\d \d{4}\] }{}gm;

  is($err, <<'EOF', "Got correct errors to stderr");
[debug] foo at t/01basic.t line 33
[info] foo at t/01basic.t line 34
[error] Gah! at t/01basic.t line 35
EOF

}

