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
if(!$command or $command eq $text{"apply_lck"} or $command eq $text{"apply_bck"}) {
	$status=`/opt/datalogger/bin/lstatus 93`;
	}
elsif($command eq $text{"apply_lic"}) {
	$status=`/opt/datalogger/bin/lstatus 93 force`;
	}

elsif($command eq $text{"apply_reg"}) {
	my @cmdlist=[ 
		[ "command" , $text{"apply_bck"} ], 
		[ "command" , $text{"apply_reg"} ], 
		];
	&ui_print_header(undef, $text{'register'}, "", undef, 1, 1);
	print ui_form_start('licensing.cgi',"POST");
	print "<h4>Please enter Key</h4>";
	print ui_textbox("license_key",$in{"license_key"},80);
	print ui_hr();
	if($lickey ne "") {
		$status=`/opt/datalogger/bin/lenable $lickey`;
		}
	$status.=`/opt/datalogger/bin/lstatus 93 force`;
	print "<pre>$status</pre>";
	print ui_form_end(@cmdlist);
	&ui_print_footer('', $text{'return'});
	return;
	}

elsif($command eq $text{"apply_unr"}) {
	my @cmdlist=[ 
		[ "command" , $text{"apply_bck"} ], 
		[ "command" , $text{"apply_unr"} ], 
		];
	&ui_print_header(undef, $text{'unregister'}, "", undef, 1, 1);
	print ui_form_start('licensing.cgi',"POST");
	print "<h4>Please enter Key</h4>";
	print ui_textbox("license_key",$in{"license_key"},80);
	print ui_hr();
	if($lickey ne "") {
		$status=`/opt/datalogger/bin/ldisable $lickey`;
		}
	print "<pre>$status</pre>";
	print ui_form_end(@cmdlist);
	&ui_print_footer('', $text{'return'});
	return;
	}

# default behaviour	
my @cmdlist=[ 
	[ "command" , $text{"apply_lck"} ], 
	[ "command" , $text{"apply_lic"} ], 
	[ "command" , $text{"apply_reg"} ], 
	[ "command" , $text{"apply_unr"} ], 
	];

# shows data
&ui_print_header(undef, $text{'licensing'}, "", undef, 1, 1);
print ui_form_start('licensing.cgi',"POST");
&dataloggerShowConfig(@liclist,$licfile,1);
print ui_form_end(@cmdlist);
print "<h3>License Check:</h3><pre>$status</pre>";
&ui_print_footer('', $text{'return'});
