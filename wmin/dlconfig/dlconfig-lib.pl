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

sub dlconfig_save {

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

	print &ui_table_start($text{"dlconfig_dredit"}.": ".$module);
	&dataloggerShowConfig(\@plist,"/tmp/$module.edit");
	print &ui_table_end();

	@cmdlist=[ ["command" , $text{"save_data"} ], [ "command" , $text{"cancel_data"} ]  ];
	}

sub dlconfig_display {

	my ($module,$value) = @_;

	print &ui_table_start($text{"dlconfig_drshow"}.": ".$module);
	$filedata=`/opt/datalogger/api/iifConfig $module print`;
	&dataloggerCsvOut($filedata);
	print &ui_table_end();

	@cmdlist=[ [ "command" , $text{"create_data"} ], [ "command", $text{"delete_data"} ] ];
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
	elsif($in{"module"} ne "") {
		$module=$in{"module"};
		}
	if($in{"command"} ne "") {
		$command=$in{"command"};
		}

	# sets form management
	print &ui_form_start('mod_config.cgi',"POST");

	# Creates new config - here to update correctly buttons.
	if($command eq $text{"save_data"}) {
		&dlconfig_save($module);
		}
	# Earse alla Config - here to update correctly buttons.
	elsif($command eq $text{"delete_data"}) {
		&dlconfig_delete($module);
		}
	elsif($command eq $text{"create_data"}) {
		&dlconfig_create($module);
		}
	# default action
	elsif($module ne "")  {
		&dlconfig_display($module,);
		}


	# Active Modules
	print &dataloggerVarHtml("moduleSelectActive",$module);	

	# saves last command for re-usage
	print ui_hidden("module",$module);
	print ui_form_end(@cmdlist);
	}

