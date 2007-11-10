package MooseX::LogDispatch::Configurator::FileBased;

use Moose::Role;
use Log::Dispatch::Configurator::AppConfig;

has config_filename => (
  isa      => 'Str',
  is       => 'rw',
  required => 1,
);

has configurator => (
    isa      => 'Log::Dispatch::Configurator',
    is       => 'ro',
    lazy     => 1,
    required => 1,
    default  => sub {
        return Log::Dispatch::Configurator::AppConfig->new( $_[0]->config_filename)
    },
);


1;
