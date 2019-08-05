#!/usr/bin/perl

use WebminCore;
init_config();

# Base libraru for Datalogger System
use datalogger_lib;

sub  dllastdata_buttons {
	&dataloggerShowSubmitModule($text{'dllastdata_active'});
	}

# Raw data format - best to specilize
sub dllastdata_show {
	
	# reads pressed button
	my $module=&dataloggerReadSubmitModule();
       $module eq undef && return;

	# Gets buttons name from API
	my $bdescr=`/opt/datalogger/api/iifAltDescr $module`;
	
	# File statistics
	my $filestat=`stat /tmp/$module.last`;
	print &ui_table_start($text{'dllastdata_drdata'}.": ".$bdescr);
	print "<pre>$filestat</pre>";
	print &ui_table_end(); 

	# outputs data 
	my $filedata=`/opt/datalogger/api/iifLast $module`;
	&dataloggerFileOut($text{'dllastdata_result'}.": ".$bdescr,$filedata);
	}

