#!/usr/bin/perl

use WebminCore;
init_config();

use datalogger_lib;
sub  dlconfig_buttons {
	&dataloggerShowSubmitModule($text{"dlconfig_active"});	
	}

# Raw data format - best to specilize
sub dlconfig_show {

	my $module=&dataloggerReadSubmitModule();
	$module eq undef && return;

	my $bdescr=`/opt/datalogger/api/iifAltDescr $module`;
	my $filedata=`cd /opt/datalogger;api/iifConfig $module print `;

	# outputs data
	&dataloggerFileOut($text{"dlconfig_drdata"}.": ".$bdescr,$filedata);
	}

