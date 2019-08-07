use WebminCore;
use datalogger_lib;

init_config();

# hardcoded!!!
my $filename="/opt/datalogger/etc/datalogger";

# List of fields for this module
my @flist=[
	[ "COMMPAUSE","checkbox",undef ],
	[ "COMMFREQ","number",3 ],
	[ "POLLPAUSE","checkbox",undef ],
	[ "POLLFREQ", "number",3 ],
	[ "SYNCPAUSE","checkbox",undef ],
	[ "SYNCFREQ", "number",3 ],
	[ "DLDESCR", "text",60]
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
