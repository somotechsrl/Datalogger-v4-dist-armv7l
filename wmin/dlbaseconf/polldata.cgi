#!/usr/bin/perl

require 'dlbaseconf-lib.pl';

# hardcoded!!!
my $filename="/opt/datalogger/etc/datalogger";

# List of fields for this module
my @flist=[
	"COMMPAUSE","COMMFREQ",
	"POLLPAUSE","POLLFREQ",
	"SYNCPAUSE","SYNCFREQ",
	"AGGRESSIVE_POLL",
	"INETPING",
	"DLDESCR"
];

sub show_polldata {
	print ui_form_start('polldata.cgi',"POST");
	&dataloggerShowConfig(@flist,$filename);
	print ui_form_end([ [ "command" , $text{'save'} ] ]);
	}

sub save_polldata {
	&dataloggerSaveConfig(@flist,$filename);
	}

&ui_print_header(undef, $text{'working'}, "", undef, 1, 1);

ReadParse();

if($in{"command"} eq $text{"save"}) {
	&save_polldata();
	}

&show_polldata();
&ui_print_footer("", $text{'return'});


