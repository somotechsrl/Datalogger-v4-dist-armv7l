#!/usr/bin/perl

use WebminCore;
use datalogger_lib;
use datalogger_var;

init_config();

sub dlconfig_delete {

	my ($module,$row) = @_;

	foreach $r (keys %in) {
		if($r =~ /row_/) {
			callDataloggerAPI("iifConfig $module del $in{$r}");
			}
		}
	}

sub dlconfig_save {

	my ($module) = @_;

	# get params list via API
	$params=callDatalloggerAPI("iifConfig $module params");
	@parray=split /[\n\r ]/,$params;

	# generates from POST
	my $pdata;
	foreach $p (@parray) {
		$pdata.=" '$in{$p}'";
		}
	callDataloggerAPI("iifConfig $module add $pdata");
	}


sub dlconfig_create {

	my ($module) = @_;

	# create new rowe/config
	@plist=split /[\n\r ]/, callDatalloggerAPI("iifParams '$module'");

	print &ui_table_start($text{"dlconfig_dredit"}.": ".$module);
	&dataloggerShowConfig(\@plist,"/tmp/$module.edit");
	print &ui_table_end();

	}

sub dlconfig_display {

	my ($module,$value) = @_;

	print &ui_table_start($text{"dlconfig_drshow"}.": ".$module);
	$filedata=callDatalloggerAPI("iifConfig $module print");
	&dataloggerCsvOut($filedata);
	print &ui_table_end();
	}

sub dlconfig_enable {
	my ($module) = @_;
	return callDataloggerAPI("iifEnable $module");
	}

sub dlconfig_disable {
	my ($module) = @_;
	return callDatalloggerAPI("iifDisable $module");
	}

