#!/usr/bin/perl

use WebminCore;
init_config();

sub  dllastdata_buttons {
	my $fn,@fl;
	$fn=`ls /tmp | grep .last`;
	$fn =~ s/[.].*//g;
	@fl = split(/[ \t\n\r]/,$fn);	
	
	#print @fl;
	print ui_buttons_start();
	foreach my $button_name (@fl) {
		#print $button_name;
		print ui_button($button_name);
		}
	print ui_buttons_end();
	}

