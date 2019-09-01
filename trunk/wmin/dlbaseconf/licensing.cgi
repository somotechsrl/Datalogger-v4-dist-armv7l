#!/usr/bin/perl

require 'dlbaseconf-lib.pl';

# harcoded vars
my $licfile="/opt/datalogger/etc/.license";
my @liclist=["licdlserial","licreleased","licexpiration","licgenerated","licsha256sum"];
my @cmdlist=[ 
	[ "command" , $text{"apply_lck"} ], 
	[ "command" , $text{"apply_lic"} ], 
	[ "command" , $text{"apply_reg"} ], 
	];

# read post
ReadParse();
$command=$in{"command"};

# renew license
my $force="";
if($command eq $text{"apply_lic"}) {
	$force="force";
	}
$status=`/opt/datalogger/bin/lstatus 93 $force`;
	
# shows data
&ui_print_header(undef, $text{'licensing'}, "", undef, 1, 1);
print ui_form_start('licensing.cgi',"POST");
&dataloggerShowConfig(@liclist,$licfile,1);
print "<pre>$status</pre>";
print ui_form_end(@cmdlist);
&ui_print_footer('', $text{'return'});
