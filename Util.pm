=head1 NAME

Watchdog::Util - Watchdog utility functions

=head1 SYNOPSIS

  use Watchdog::Util;

=head1 DESCRIPTION

=cut

package Watchdog::Util;

use strict;
use vars qw($AUTOLOAD);

#------------------------------------------------------------------------------

sub AUTOLOAD {
  my $self  = shift;
  my $type  = ref($self) or die "$self is not an object";

  my $name = $AUTOLOAD;
  $name =~ s/.*://;     # strip fully-qualified portion

  # accessor methods
  $name = uc($name);
  return if ( $name eq 'DESTROY' );  # don't catch 'DESTROY'
  unless ( exists $self->{_PERMITTED}->{$name} ) {
    die "Can't access `$name' field in class $type";
  }
  return @_ ? $self->{$name} = shift : $self->{$name};
}

=head1 AUTHOR

Paul Sharpe I<lt>paul@miraclefish.comE<gt>

=head1 COPYRIGHT

Copyright (c) 1998 Paul Sharpe. England.  All rights reserved.  This
program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
