use ExtUtils::MakeMaker;

WriteMakefile(
	      'NAME'	     => 'Watchdog::Service',
	      'DISTNAME'     => 'WatchdogService',
	      'VERSION_FROM' => 'Service.pm',
	      'PREREQ_PM'    => { 'Alias' => 0, 'Proc::ProcessTable' => 0, },
);
