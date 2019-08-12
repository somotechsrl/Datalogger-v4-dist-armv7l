use WebminCore;
use datalogger_lib;
use datalogger_var;

init_config();

# hardcoded!!!
my $licfile="/opt/datalogger/etc/.license";
my $filename="/opt/datalogger/etc/datalogger";

# List of fields for this module
my @flist=[
	"COMMPAUSE","COMMFREQ",
	"POLLPAUSE","POLLFREQ",
	"SYNCPAUSE","SYNCFREQ",
	"DLDESCR"
];

my @liclist=[
	"type","released","expiration","generated","md5sum","sha1sum"
	];

sub show_polldata {
	print ui_form_start('dlbaseconf_save.cgi',"POST");
	&dataloggerShowConfig(@flist,$filename);
	print ui_form_end([ [ undef, $text{'dlbaseconf_save'} ] ]);
	}

sub show_licensing {
	print ui_form_start('dlbaseconf_licensing.cgi',"POST");
	&dataloggerShowConfig(@liclist,$licfile,1);
	print ui_form_end([ [ undef, $text{'dlbaseconf_apply_lic'} ] ]);
	}

sub save_polldata {
	&dataloggerSaveConfig(@flist,$filename);
	}

sub dlbaseconf_delete {

	my ($module,$row) = @_;

	foreach $r (keys %in) {
		if($r =~ /row_/) {
			callDataloggerAPI("iifConfig $module del $in{$r}");
			}
		}
	}

sub dlbaseconf_save {

	my ($module) = @_;

	# get params list via API
	$params=callDataloggerAPI("iifConfig $module params");
	@parray=split /[\n\r ]/,$params;

	# generates from POST
	my $pdata;
	foreach $p (@parray) {
		$pdata.=" '$in{$p}'";
		}
	callDataloggerAPI("iifConfig $module add $pdata");
	}


sub dlbaseconf_create {

	my ($module) = @_;

	# create new rowe/config
	@plist=split /[\n\r ]/, callDataloggerAPI("iifParams '$module'");

	print &ui_table_start($text{"dlbaseconf_dredit"}.": ".$module);
	&dataloggerShowConfig(\@plist,"/tmp/$module.edit");
	print &ui_table_end();

	}

sub dlbaseconf_display {

	my ($module,$value) = @_;

	print &ui_table_start($text{"dlbaseconf_drshow"}.": ".$module);
	$filedata=callDataloggerAPI("iifConfig $module print");
	&dataloggerCsvOut($filedata);
	print &ui_table_end();
	}

sub dlbaseconf_enable {
	my ($module) = @_;
	return callDataloggerAPI("iifEnable $module");
	}

sub dlbaseconf_disable {
	my ($module) = @_;
	return callDataloggerAPI("iifDisable $module");
	}

