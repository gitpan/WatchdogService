# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

use strict;
use Test;
BEGIN { plan tests => 6 }

use Watchdog::Service;
use Watchdog::HTTPService;
use Watchdog::MysqlService;

my @service = ( new Watchdog::HTTPService,
		new Watchdog::HTTPService(undef,'www.microsoft.com'),
		new Watchdog::MysqlService,
		new Watchdog::MysqlService(undef,'www.tcx.se'),
		new Watchdog::Service('sendmail','sendmail'),
		new Watchdog::Service('foobar','foobar'),
	      );

for ( @service ) {
  print $_->id, ' is ... ';
  my $alive = $_->is_alive;
  if ( $alive == 0 || $alive == 1 ) {
    print $alive ? "alive\n" : "dead\n";
    ok(1);
  } else {
    ok(0);
  }
}
