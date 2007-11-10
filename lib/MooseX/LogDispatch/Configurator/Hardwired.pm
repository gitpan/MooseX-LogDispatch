package MooseX::LogDispatch::Configurator::Hardwired;

use Moose::Role;

use MooseX::LogDispatch::Configurator::Engine::Hardwired;

has configurator => (
    isa      => 'Log::Dispatch::Configurator',
    is       => 'ro',
    lazy     => 1,
    required => 1,
    default  => sub {
        return MooseX::LogDispatch::Configurator::Engine::Hardwired->new;
    },
);

#with 'MooseX::LogDispatch::Engine::Config';

1;
