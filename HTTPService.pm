package Watchdog::HTTPService;

use strict;
use Alias;
use base qw(Watchdog::Service);
use HTTP::Request;
use LWP::UserAgent;
use vars qw($VERSION $HOST $PORT);

$VERSION = '0.01';

=head1 NAME

Watchdog::HTTPService - Monitor HTTP service

=head1 SYNOPSIS

  use Watchdog::HTTPService;
  $h = new Watchdog::HTTPService($name,$host,$port);
  print $h->id, $h->is_alive ? ' is alive' : ' is dead', "\n";

=head1 DESCRIPTION

B<Watchdog::HTTPService> is an extension for monitoring an HTTP
server running on a Unix host.

=cut

my($name,$port) = ('httpd',80);

=head1 CLASS METHODS

=head2 new($name,$host,$port)

Returns a new B<Watchdog::HTTPService> object.  I<$name> is a string
which will identify the service to a human (default is 'httpd').
I<$host> is the hostname which is running the service (default is
'localhost').  I<$port> is the port on which the service listens
(default is 80).

=cut

sub new($$$) {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  $_[0] = $name unless defined($_[0]);
  $_[2] = $port unless defined($_[2]); 
  my $self  = bless($class->SUPER::new($_[0],'httpd',@_[1..2]),$class);
  return $self;
}

#------------------------------------------------------------------------------

=head1 OBJECT METHODS

=head2 is_alive()

Returns true if an HTTP B<GET> method succeeds for the URL
B<http://$host:$port/> or false if it doesn't.

=cut

sub is_alive() {
  my $self = attr shift;
  my $request  = new HTTP::Request(GET => "http://$HOST:$PORT/");
  my $ua       = new LWP::UserAgent;
  my $response = $ua->request($request);
  return $response->is_success ? 1 : 0;
}

#------------------------------------------------------------------------------

=head1 SEE ALSO

L<Watchdog::Service>

=head1 AUTHOR

Paul Sharpe E<lt>paul@miraclefish.comE<gt>

=head1 COPYRIGHT

Copyright (c) 1998 Paul Sharpe. England.  All rights reserved.  This
program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
