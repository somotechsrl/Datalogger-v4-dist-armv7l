#!/usr/bin/perl

use WebminCore;
init_config();

sub  dllastdata_buttons {
	my $fn,@fl;
	$fn=`ls /tmp | grep .last`;
	$fn =~ s/[.].*//g;
	@fl = split " " $fn;	
	
	ui_buttons_start();
	foreach my $button_name (@fl) {
		ui_button('show.cgi',$button_name);
		}
	ui_buttons_end();
	}

