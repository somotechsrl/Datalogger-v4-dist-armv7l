#!/usr/bin/perl

use Switch;
use WebminCore;
use datalogger_lib;
init_config();

sub  dlconfigdb_buttons {
	my $fn,@fl,$button_desc;
	$fn=`ls /opt/datalogger/etc/iif.d`;
	$fn =~ s/[.].*//g;
	@fl = split(/[ \t\n\r]/,$fn);	
	
	#print @fl;
	print &ui_form_start("index.cgi","post");
	print &ui_table_start($text{'dlconfig_active'});
	foreach my $button_name (@fl) {
		#print $button_name;
		#$button_desc=`/opt/datalogger/api/iifDescr $button_name`;
		my $bdescr=`/opt/datalogger/api/iifAltDescr $button_name`;
		print &ui_submit($bdescr,$button_name,0,'style="min-width: 20em;"');
		}
	print &ui_table_end();
	print &ui_form_end();
	}

# Raw data format - best to specilize
sub dlconfigdb_show {

	# loads submit parameters and connects to api - gets CSV format
	ReadParse();
	my @pressed=keys %in;

	# DL API queries
	my $module=@pressed[0];
	my $bdescr=`/opt/datalogger/api/iifAltDescr $module`;
	my $filedata=`cd /opt/datalogger;api/iifConfig $module print `;

	# outputs data
	dataFileOut($sbdescr,$filedata);
	}

