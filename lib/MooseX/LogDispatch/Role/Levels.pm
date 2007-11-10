package MooseX::LogDispatch::Role::Levels;

use Moose::Role;
use MooseX::LogDispatch::Interface;

# Ideally i would like to be able to d
#
# with 'MooseX::LogDispatch::Role::Default';
# has '+logger' => ( handles => 'MooseX::LogDispatch::Interface' );
#
# but it doesn't work for some reason.
#
use Log::Dispatch::Config;
has logger => (
    isa      => 'Log::Dispatch::Config',
    is       => 'rw',
    lazy     => 1,
    required => 1,
    default  => sub {
        my $self = shift;
        Log::Dispatch::Config->configure( $self->configurator );
        my $logger = Log::Dispatch::Config->instance;
        return $logger;
    },
    handles => 'MooseX::LogDispatch::Interface' 

);


no Moose::Role;
