package MooseX::LogDispatch::Role::Default;

use Moose::Role;

use Log::Dispatch::Config;

#requires 'configurator';

has logger => (
    isa      => 'Log::Dispatch::Config',
    is       => 'rw',
    lazy     => 1,
    required => 1,
    default  => sub {
        my $self = shift;
        Log::Dispatch::Config->configure( $self->configurator );
        my $logger = Log::Dispatch::Config->instance;
        $DB::single = 1;
        return $logger;
    },

);

no Moose::Role;
