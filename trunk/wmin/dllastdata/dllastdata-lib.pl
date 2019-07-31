#!/usr/bin/perl

use WebminCore;
init_config();

sub  dllastdata_buttons {
	my $fn;
	fn=`ls /tmp | grep .last`;
	$fn =~ s/[.].*//g;
	return $fn;
	}

