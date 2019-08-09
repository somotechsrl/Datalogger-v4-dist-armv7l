use WebminCore;
use datalogger_lib;
use datalogger_var;

init_config();

# hardcoded!!!
my $filename="/opt/datalogger/etc/datalogger";

# List of fields for this module
my @flist=[
	"COMMPAUSE","COMMFREQ",
	"POLLPAUSE","POLLFREQ",
	"SYNCPAUSE","SYNCFREQ",
	"DLDESCR"
];

sub show_polldata {
	ui_print_header(undef, $module_info{'head'}, "", undef, 1, 1);
	print ui_form_start('save.cgi',"POST");

	&dataloggerShowConfig(@flist,$filename);
	
	print ui_form_end([ [ undef, $text{'save'} ] ]);
	ui_print_footer('/', $text{'index'});
	}

sub save_polldata {
	&dataloggerSaveConfig(@flist,$filename);
	&show_polldata(@flist,$filename);
	}
