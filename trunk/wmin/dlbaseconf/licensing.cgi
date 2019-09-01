#!/usr/bin/perl

require 'dlbaseconf-lib.pl';

# harcoded vars
my $licfile="/opt/datalogger/etc/.license";
my @liclist=["licdlserial","licreleased","licexpiration","licgenerated","licsha256sum"];

# read post
ReadParse();
$command=$in{"command"};
$lickey=$in{"license_key"};

# renew license
my $force="";
if($command eq $text{"apply_lic"}) {
	$force="force";
	}

$status=`/opt/datalogger/bin/lstatus 93 $force`;

if($command eq $text{"apply_reg"}) {
	my @cmdlist=[ 
		[ "command" , $text{"apply_bck"} ], 
		[ "command" , $text{"apply_reg"} ], 
		];
	&ui_print_header(undef, $text{'registering'}, "", undef, 1, 1);
	print ui_form_start('licensing.cgi',"POST");
	print "<h4>Please enter Bundle Activation key</h4>";
	print ui_textbox("license_key",$in{"license_key"},80);
	print ui_hr();
	if($lickey ne "") {
		$status=`/opt/datalogger/bin/lenable $lickey`.$status;
		}
	print "<pre>$status</pre>";
	print ui_form_end(@cmdlist);
	&ui_print_footer('', $text{'return'});
	}

# default behaviour	
my @cmdlist=[ 
	[ "command" , $text{"apply_lck"} ], 
	[ "command" , $text{"apply_lic"} ], 
	[ "command" , $text{"apply_reg"} ], 
	];


# shows data
&ui_print_header(undef, $text{'licensing'}, "", undef, 1, 1);
print ui_form_start('licensing.cgi',"POST");
&dataloggerShowConfig(@liclist,$licfile,1);
print "<pre>$status</pre>";
print ui_form_end(@cmdlist);
&ui_print_footer('', $text{'return'});
