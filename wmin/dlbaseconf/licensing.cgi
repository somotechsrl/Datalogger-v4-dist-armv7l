#!/usr/bin/perl

require 'dlbaseconf-lib.pl';

# harcoded vars
my $licfile="/opt/datalogger/etc/.license";
my @liclist=["lictype","licreleased","licexpiration","licgenerated","licmd5sum","licsha256sum"];
my @cmdlist=[ [ "command" , $text{"apply_lic"} ], ];

# read post
ReadParse();
$command=$in{"command"};

# renew license
if($command eq $text{"apply_lic"}) {
	`/opt/datalogger/bin/lstatus force`;
	}
	
# shows data
&ui_print_header(undef, $text{'licensing'}, "", undef, 1, 1);
print ui_form_start('licensing.cgi',"POST");
&dataloggerShowConfig(@liclist,$licfile,1);
print ui_form_end(@cmdlist);
&ui_print_footer("command", $text{'return'});
