#!/usr/bin/perl

use WebminCore;
use datalogger_lib;
use datalogger_var;

init_config();


sub dlconfig_delete {

	my ($module,$row) = @_;

	foreach $r (keys %in) {
		if($r =~ /row_/) {
			`/opt/datalogger/api/iifConfig $module del $in{$r}`;
			}
		}
	}

sub dlconfig_remove {

	my ($module) = @_;

	`/opt/datalogger/api/iifConfig $module remove`;
	}

sub dlconfig_addrow {

	my ($module) = @_;

	# get params list via API
	$params=`/opt/datalogger/api/iifConfig $module params`;
	@parray=split /[\n\r ]/,$params;

	# generates from POST
	my $pdata;
	foreach $p (@parray) {
		$pdata.=" '$in{$p}'";
		}
	`/opt/datalogger/api/iifConfig $module add $pdata`;
	}


sub dlconfig_create {

	my ($module) = @_;

	# create new rowe/config
	@plist=split /[\n\r ]/, `/opt/datalogger/api/iifParams '$module'`;

	print ui_table_start($text{"dlconfig_dredit"}.": ".$module);
	&dataloggerShowConfig(\@plist,"/tmp/$module.edit");
	print &ui_table_end();


	}

sub dlconfig_display {

	my ($module) = @_;

	print &ui_table_start($text{"dlconfig_drshow"}.": ".$module);
	$filedata=`/opt/datalogger/api/iifConfig $module print`;
	&dataloggerCsvOut($filedata);
	print &ui_table_end();
	}

# Raw data format - best to specilize
sub dlconfig_show {

	ReadParse();
	dd %in;

	# work variables
	my $command, my $module;

	# searches command and module -- priority tu submit buttons..
	$command=$in{"command"};
	if($in{"moduleButton"} ne "") {
		$module=$in{"moduleButton"};
		}
	elsif($in{"moduleSelect"} ne "") {
		$module=$in{"moduleSelect"};
		}
	else {
		$command=$in{"last_command"};
		}

	print "***** $command +++ $module";

	# Earse alla Config - here to update correctly buttons.
	if($command eq $text{"remove"}) {
		&dlconfig_remove($module);
		}
	# if we are saving append data via API
	if($command eq $text{"save"}) {	
		&dlconfig_addrow($module);
		}
	# Delete Config row(s) via API
	if($command eq $text{"delete"}) {
		&dlconfig_delete($module,$row);
		}

	# sets form management
	print &ui_form_start('index.cgi',"POST");

	print &ui_table_start($text{"dlconfig_select"});
	print &ui_buttons_start();
	print &dataloggerVarHtml("moduleSelect",$module);
	print &ui_submit($text{"find"});
	print &ui_buttons_end();
	print &ui_table_end();

	# Active Modules
	&dataloggerShowSubmitModule($text{"dlconfig_active"},0);	

	# no module defined - do nothing
	if(!$module) {
		print ui_form_end();
		return;
		}

	# check 'insert button' -- show form
	my @cmdlist;

	# create new rowe/config
	if($command eq $text{"create"}) {
		&dlconfig_create($module);
		@cmdlist=[ ["command" , $text{"save"} ], [ "command" , $text{"cancel"} ]  ];
		}

	# default action
	else {
		&dlconfig_display($module);
		@cmdlist=[ [ "command" , $text{"create"} ], ["command" , $text{"delete"} ], [ "command", $text{"remove"} ] ];
		}


	# saves last command for re-usage
	print ui_hidden("last_command",$command);
	print ui_form_end(@cmdlist);
	}

