package Watchdog::Service;

use strict;
use Alias;
use Proc::ProcessTable;
use base qw(Watchdog::Util);
use vars qw($VERSION $NAME $PSTRING $HOST $PORT);

$VERSION = '0.03';

=head1 NAME

Watchdog::Service - Perl extension to monitor services

=head1 SYNOPSIS

  use Watchdog::Service;
  $s = new Watchdog::Service($name,$pstring);
  print $s->id, $s->is_alive ? ' is alive' : ' is dead', "\n";

=head1 DESCRIPTION

B<Watchdog::Service> is an extension for monitoring services running
on a Unix host.  The class provides a trivial method for determining
whether a service is alive.  More sophisticated methods can be
implemented by creating subclasses of B<Watchdog::Service>
e.g. B<Watchdog::HTTPService> uses the status of an HTTP 'GET' method
to decide if a web server is alive.

=head1 EXAMPLE

  use Watchdog::Service;

  my @service = ( new Watchdog::Service('Apache','httpd'),
                  new Watchdog::Service('INN','innd'),
                );

  for ( @service ) {
    print $_->id, $_->is_alive ? ' is alive' : ' is dead', "\n";
  }

=cut

my %fields = (
	      NAME    => undef,
	      PSTRING => undef,
	      HOST    => 'localhost',
	      PORT    => undef,
);

=head1 CLASS METHODS

=head2 new($name,$pstring)

Returns a new B<Watchdog::Service> object.  I<$name> is a string which
will identify the service to a human.  I<$pstring> is a string which
can be used to identify a process providing the service.

=cut

sub new($$$$) {
  my $DEBUG = 0;
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self  = bless { _PERMITTED => \%fields, %fields, },$class;
  attr $self;

  print STDERR "Watchdog::Service::new() $NAME $HOST $PORT\n" if $DEBUG;
  my $arg;
  for (\$NAME,\$PSTRING,\$HOST,\$PORT) {
    $$_ = $arg if $arg = shift;
  }
  print STDERR "Watchdog::Service::new() $NAME $HOST $PORT\n" if $DEBUG;

  return $self;
}

#------------------------------------------------------------------------------

=head1 OBJECT METHODS

=head2 id()

Return a string describing the Mysql service.

=cut

sub id() {
  my $self = attr shift;
  my $id = "$NAME\@$HOST";
  $id .= ":$PORT" if defined($PORT);
  return $id;
}

#------------------------------------------------------------------------------

=head2 is_alive()

Returns true if the service is alive, else false.

=cut

sub is_alive() {
  my $self = attr shift;
  my $t    = new Proc::ProcessTable;

  for ( @{$t->table} ) {
    # Proc::ProcessTable::Process::cmndline() seems to return
    # undefined sometimes.  Bug reported to author.
    my $cmndline = $_->cmndline;
    return 1 if defined($cmndline) && $cmndline =~ /$PSTRING/;
  }
  return 0;
}

#------------------------------------------------------------------------------

=head1 SEE ALSO

L<Watchdog::HTTPService> and L<Watchdog::MysqlService>

=head1 AUTHOR

Paul Sharpe E<lt>paul@miraclefish.comE<gt>

=head1 COPYRIGHT

Copyright (c) 1998 Paul Sharpe. England.  All rights reserved.  This
program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
