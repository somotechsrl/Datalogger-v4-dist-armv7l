#!/usr/bin/perl

use WebminCore;
use datalogger_lib;

init_config();

# Raw data format - best to specilize
sub dlconfig_show {

	my ($module) = @_;

	print ui_form_start('index.cgi',"POST");
	# gets parameters from API
	$params=`/opt/datalogger/api/iifParams '$module'`;
	@plist=split / / , $params;
	#push(@plist,"hidden_module");
	&dataloggerShowConfig(\@plist,"/tmp/$module.edit");
	print ui_form_end([ [ undef, $text{'save'} ] ]);
	}

sub show_polldata {

	&dataloggerShowConfig(@flist,$filename);

	}

sub save_polldata {
	&dataloggerSaveConfig(@flist,$filename);
	&show_polldata(@flist,$filename);
	}
