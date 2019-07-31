#!/usr/bin/perl

use WebminCore;
init_config();

sub  dlquerydb_buttons {
	my $fn,@fl,$button_desc;
	$fn=`ls /tmp | grep .last`;
	$fn =~ s/[.].*//g;
	@fl = split(/[ \t\n\r]/,$fn);	
	
	#print @fl;
	print ui_form_start("index.cgi","post");
	print ui_buttons_start();
	foreach my $button_name (@fl) {
		#print $button_name;
		$button_desc=`/opt/datalogger/api/iifDescr $button_name`;
		print ui_submit($button_desc ne '' ? $button_desc : $button_name,$button_name,0,"value=1 style='max-width: 20em;width: 20em;'");
		}
	print ui_buttons_hr();
	print ui_buttons_end();
	print ui_form_end();
	}

sub dlquerydb_show {
	ReadParse();
	my @pressed=keys %in;
	my $command='/opt/datalogger/api/iifLast '.@pressed[0];
	my $result=`$command`;
	if($result ne '') {
		print `$command`;
		}

	}

