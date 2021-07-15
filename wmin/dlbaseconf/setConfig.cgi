#!/usr/bin/perl
# Show Datalogger Status

require 'dlbaseconf-lib.pl';

# start of ui
ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

ReadParseMime();
#print %in;

# work variables
my $command, my $module;
print %in;

# command to exec
if($in{"command"} ne "") {
	$command=$in{"command"};
	}

# Creates new config - here to update correctly buttons.
if($command eq $text{"setConfig"}) {
	$status="Executed";
	}

my @cmdlist=[ 
	[ "command" , $text{"setConfig"} ], 
	];

print &ui_form_start('dlupdate.cgi',"POST");
print ui_upload("setConfig_file",80);
print &ui_form_end(@cmdlist);

# end of ui
print "<h3>Command Result:</h3><pre>$status</pre>";
&ui_print_footer("", $text{'return'});
