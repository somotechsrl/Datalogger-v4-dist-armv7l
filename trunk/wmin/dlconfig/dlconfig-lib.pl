#!/usr/bin/perl

use WebminCore;
init_config();

use datalogger_lib;
sub  dlconfig_buttons {
	&dataloggerShowSubmitModule($text{"dlconfig_active"});	
	}

# Raw data format - best to specilize
sub dlconfig_show {

	my ($module) = @_;

	if($module eq undef) {
		print &ui_table_start($text{"dlconfig_drundef"});
		print $ui_table_end();
		return;
		}

	my $bdescr=`/opt/datalogger/api/iifAltDescr $module`;
	my $filedata=`cd /opt/datalogger;api/iifConfig $module print `;

	# outputs data
	&dataloggerFileOut($text{"dlconfig_drdata"}.": ".$bdescr,$filedata);
	}

