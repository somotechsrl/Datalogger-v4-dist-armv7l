use WebminCore;
use datalogger_lib;
use datalogger_var;

init_config();

# hardcoded!!!
my $licfile="/opt/datalogger/saved/.awawawa";
my $filename="/opt/datalogger/etc/datalogger";

# List of fields for this module
my @flist=[
	"COMMPAUSE","COMMFREQ",
	"POLLPAUSE","POLLFREQ",
	"SYNCPAUSE","SYNCFREQ",
	"DLDESCR"
];

my @liclist=[
	"type","released","expiration"
	];

sub show_polldata {
	print ui_form_start('dlbaseconf_save.cgi',"POST");
	&dataloggerShowConfig(@flist,$filename);
	print ui_form_end([ [ undef, $text{'dlbaseconf_save'} ] ]);
	}

sub show_licensing {
	print ui_form_start('dlbaseconf_licensing.cgi',"POST");
	&dataloggerShowConfig(@liclist,$licfile);
	print ui_form_end([ [ undef, $text{'dlbaseconf_renew'} ] ]);
	}

sub save_polldata {
	&dataloggerSaveConfig(@flist,$filename);
	}
