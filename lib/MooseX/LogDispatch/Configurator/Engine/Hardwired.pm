package MooseX::LogDispatch::Configurator::Engine::Hardwired;
use Moose;
BEGIN { extends qw(Log::Dispatch::Configurator); }

sub get_attrs_global {
    my $self = shift;
    return {
        format      => undef,
        dispatchers => [qw(screen)],
    };
}

sub get_attrs {
    my ( $self, $name ) = @_;
    if ( $name eq 'screen' ) {
        return {
            class     => 'Log::Dispatch::Screen',
            min_level => 'debug',
            stderr    => 1,
            format    => '[%d] [%p] %m at %F line %L%n',
        };
    }
    else {
        die "invalid dispatcher name: $name";
    }
}

sub needs_reload { 1 }
no Moose;
1;
__END__