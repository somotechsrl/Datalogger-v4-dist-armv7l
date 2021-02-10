#!/usr/bin/perl

require 'dlbaseconf-lib.pl';

# hardcoded!!!
my $filename="/opt/datalogger/etc/datalogger";

# List of fields for this module
my @flist=[
	"MQTT_USER","MQTT_PASS"
];

sub show_rpcconfig {
	print ui_form_start('rpcconfig.cgi',"POST");
	&dataloggerShowConfig(@flist,$filename);
	print ui_form_end([ [ "command" , $text{'save'} ] ]);
	}

sub save_rpcconfig {
	&dataloggerSaveConfig(@flist,$filename);
	}

&ui_print_header(undef, $text{'working'}, "", undef, 1, 1);

ReadParse();

if($in{"command"} eq $text{"save"}) {
	&save_rpcconfig();
	}

&show_rpcconfig();
&ui_print_footer("", $text{'return'});


