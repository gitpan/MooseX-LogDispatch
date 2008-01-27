package MooseX::LogDispatch::Compat::FileBased;

use Moose::Role;

has config_filename => (
  isa      => 'Str',
  is       => 'rw',
  required => 1,
);

1;
