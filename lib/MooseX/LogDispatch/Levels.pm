package MooseX::LogDispatch::Levels;

use Moose::Role;
use MooseX::LogDispatch::Interface;

# Ideally i would like to be able to do
#
with 'MooseX::LogDispatch';
#has '+logger' => ( handles => 'MooseX::LogDispatch::Interface' );
#
# but it doesn't work for some reason.
#

sub _handle_log {
  my ($self, $level, @args) = @_;
  local $Log::Dispatch::Config::CallerDepth = $Log::Dispatch::Config::CallerDepth + 2;
  $self->logger->$level(@args);
}

sub log { shift->_handle_log('log',@_) }
sub debug { shift->_handle_log('debug', @_) }
sub info { shift->_handle_log('info',@_) }
sub notice { shift->_handle_log('notice',@_) }
sub warning { shift->_handle_log('warning',@_) }
sub error { shift->_handle_log('error',@_) }
sub critical { shift->logger('critical',@_) }
sub alert { shift->_handle_log('alert',@_) }
sub emergency { shift->_handle_log('emergency',@_) }

no Moose::Role;

__END__

=head1 NAME

MooseX::LgoDispatch::Levels

=head1 SYNOPSIS

 package MyLogger;
 use Moose;
 with 'MooseX::LogDispatch::Levels';

 # Optional confuration attribute would go here.

 # Elsewhere...

 my $logger = MyLogger->new;
 $logger->debug("Something to log");
 $logger->logger->debug("This also works");

=head1 DESCRIPTION

Like L<MooseX::LogDispatch>, but with methods for the various log levels
added directly to your class.

Configuration is done in the exact same way as for MooseX::LogDispatch.

=head1 METHODS

=head2 log

=head2 debug

=head2 info

=head2 notice

=head2 warning

=head2 error

=head2 critical

=head2 alert

=head2 emergency

=head1 AUTHOR

Ash Berlin C<< <ash@cpan.org> >>.

=head1 LICENCE

This module is free software; you can redistribute it and/or modify it under 
the same terms as Perl itself. See L<perlartistic>.
