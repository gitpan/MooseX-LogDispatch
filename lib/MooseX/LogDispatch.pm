package MooseX::LogDispatch;

our $VERSION = '1.0000';

use Moose qw(confess);

sub import {
    my $pkg = caller();

    return if $pkg eq 'main';

    ( $pkg->can('meta') && $pkg->meta->isa('Moose::Meta::Class') )
      || confess "This package can only be used in Moose based classes";

    $pkg->meta->alias_method(
        'Logger' => sub {
            my %params = @_;
            my $config = 'MooseX::LogDispatch::Configurator::';
            $config .=
              exists $params{'config'}
              ? ucfirst( $params{'config'} )
              : 'Hardwired';

            my @roles = ($config);

            # This is a hack, it should really create an anonymous Role
            # that has exactly the Logger attribute we need, but
            # it's 2am and I'm not ready to figure that out yet
            # -- perigrin

            my $interface = 'MooseX::LogDispatch::Role::';
            $interface .=
              exists $params{'interface'}
              ? ucfirst( $params{'interface'} )
              : 'Default';
            push @roles, $interface;

            Class::MOP::load_class($_)
              || die "Could not load role (" . $_ . ") for package ($pkg)"
              foreach @roles;

            return @roles;
        }
    );

}

1;
__END__

=head1 NAME

MooseX::LogDispatch - A Logging Role for Moose

=head1 VERSION

This document describes MooseX::LogDispatch version 1.0000

=head1 SYNOPSIS

    package MyApp;
    use Moose;
    use MooseX::LogDispatch;
    
    with Logger();

    sub foo { 
        my ($self) = @_;
        $self->logger->debug("started foo");
        ....
        $self->logger->debug('ending foo');
    }
  
=head1 DESCRIPTION

L<Log::Dispatch> role for use with your L<Moose> classes.

=head1 EXPORTS

=head2 Logger(%options)

This module will export the C<Logger> method which can be used to load a
specific set of MooseX::Logdispatch roles to implement a specific combination
of features.  It is meant to make things easier, but it is by no means the only
way. You can still compose your roles by hand if you like.

The following options are understood

=over

=item B<config>

A suffix of the role you wish to use to configure the Logger. 
C<MooseX::LogDispatch::Configurator::> is prepended to this value.

Two roles are included in the dist - see L</LOGGER ROLES>

=item B<interface>

Similar to C<config>, but this controls the interfaces presented. See
L</INTERFACE ROLES> for details

=back

=head1 ACCESSORS

=head2 logger

This is the main L<Log::Dispatch::Config> object that does all the work. It 
has methods for each of the log levels, such as C<debug> or C<error>.

=head1 LOGGER ROLES

There are different ways of configuring a Log::Dispatch object. This 
distribution includes two roles:

=over

=item *

L<Hardwired|MooseX::LogDispatch::Configurator::Hardwired> - hard-wired 
semi-sane defaults that logs everything to the screen. Enough to get you going,
but you will probably not want to use this in the long run.

=item * 

L<FileBased|MooseX::LogDispatch::Configurator::FileBased> - Load config from a
file using L<Log::Dispatch::Configurator::AppConfig>

The config file is specified by using the C<config_filename> attribute:

  package MybjectWithLog;

  use Moose;

  with Logger(config => 'FileBased');

  ... 

  # Later on
  my $obj = MyObjectWithLog->new( config_filename => '/etc/project.logger.cfg');

=back

=head1 INTERFACE ROLES

=over

=item *

L<Default|MooseX::LogDispatch::Role::Default> - gives you a C<logger>
attribute which has methods to log at various levels.

=item *

L<Levels|MooseX::LogDispatch::Role::Levels> - will give you methods for each
of the various log levels dirrectly on your object:

  package MyLogger;
  use Moost;

  with Logger(interface => 'Levels');

  ...

  my $logger = MyLogger->new;
  $logger->debug('Logger created');

There will also be a C<logger> attribute.

=back

=head1 BUGS AND LIMITATIONS

No limitations have been reported.

Please report any bugs or feature requests to
C<bug-moosex-logdispatch@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

Or come bother us in C<#moose> on C<irc.perl.org>.

=head1 AUTHOR

Ash Berlin C<< <ash@cpan.org> >>

Based on work by Chris Prather  C<< <perigrin@cpan.org> >>

=head1 LICENCE AND COPYRIGHT

Some development sponsored by L<Takkle Inc.|http://takkle.com/>

Copyright (c) 2007, Ash Berlin C<< <ash@cpan.org> >>. Some rights reserved.

Copyright (c) 2007, Chris Prather C<< <perigrin@cpan.org> >>. Some rights 
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


