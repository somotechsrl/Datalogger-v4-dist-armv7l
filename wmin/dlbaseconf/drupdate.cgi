#!/usr/bin/perl
# Show Datalogger Status

require 'dlbaseconf-lib.pl';

# start of ui
ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

ReadParse();
#print %in;

# work variables
my $command, my $module;

# command to exec
if($in{"command"} ne "") {
	$command=$in{"command"};
	}

# Creates new config - here to update correctly buttons.
if($command eq $text{"apply_drupdate"}) {
	$status=`/opt/datalogger/bin/pkgupdate`;
	}

my @cmdlist=[ 
	[ "command" , $text{"apply_drupdate"} ], 
	];

print &ui_form_start('drupdate.cgi',"POST");
&display_firmware_status();
print &ui_form_end(@cmdlist);

# end of ui
print "<h3>Command Result:</h3><pre>$status</pre>";
&ui_print_footer("", $text{'return'});
