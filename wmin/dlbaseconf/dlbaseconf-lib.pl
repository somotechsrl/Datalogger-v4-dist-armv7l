use WebminCore;
use datalogger_lib;
use datalogger_var;
use URI::Encode;
init_config();


sub delete_module_entry {

	my ($module,$row) = @_;
	foreach $r (keys %in) {
		if($r =~ /row_/) {
			callDataloggerAPI("iifConfig $module del $in{$r}");
			}
		}
	}

sub save_module_entry {

	my ($module) = @_;

	# get params list via API
	$params=callDataloggerAPI("iifConfig $module params");
	@parray=split /[\n\r ]/,$params;

	# generates from POST
	my $cmd="iifConfig $module add ";
	foreach $p (@parray) {
		$cmd.=" '$in{$p}'";
		}
	callDataloggerAPI($cmd);
	}


sub create_module_entry {

	my ($module) = @_;

	# create new rowe/config
	@plist=split /[\n\r ]/, callDataloggerAPI("iifConfig '$module' 'params'");

	print &ui_table_start($text{"create_data"}.": ".$module);
	&dataloggerShowConfig(\@plist,"/tmp/$module.edit");
	print &ui_table_end();

	}

sub display_module_entry {

	my ($module,$value) = @_;

	$dlparams=&dataloggerApiParams($module);
	if(dlparams) {
		$dldescr=$text{"drshow"};
		print &ui_table_start($dldescr.": ".$module);
		#$filedata=callDataloggerAPI("iifConfig $module print");
		#&dataloggerCsvOut($filedata);
		print &ui_table_end();
		}
	else {
		$dldescr=$text{"drnoshow"};
		}
	print &dataloggerApiTableSelect("mconfig $module");
	}

sub display_firmware_status {

	if($dlparams) {		
		$dldescr=$text{"drshow"};
		print &ui_table_start($dldescr.": ".$module);
		#$filedata=callDataloggerAPI("iifConfig $module print");
		#&dataloggerCsvOut($filedata);
		print &ui_table_end();
		}
	else {
		$dldescr=$text{"drnoshow"};
		}
	print &dataloggerApiTableShow("status-firmware");
	}


sub enable_module {
	my ($module) = @_;
	return callDataloggerAPI("iifEnable $module");
	}

sub disable_module {
	my ($module) = @_;
	return callDataloggerAPI("iifDisable $module");
	}

sub install_module {
	my ($module) = @_;
	return callDataloggerAPI("iifInstall $module");
	}

sub uninstall_module {
	my ($module) = @_;
	return callDataloggerAPI("iifUninstall $module");
	}

