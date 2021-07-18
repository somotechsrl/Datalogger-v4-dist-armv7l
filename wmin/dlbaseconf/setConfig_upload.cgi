#!/usr/bin/perl
# Show Datalogger Status
require 'dlbaseconf-lib.pl';

# start of ui
ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

our(%in)
&ReadParseMime();

# work variables
my $command, my $module;

# command to exec
if($in{"command"} ne "") {
	$command=$in{"command"};
	}

print $command;

# Creates new config - here to update correctly buttons.
if($command eq $text{"setConfig"}) {
	}

my @cmdlist=[ 
	[ "command" , $text{"setConfig"} ], 
	];

print &ui_form_start('setConfig_upload.cgi',"form-data");
print ui_upload("setConfig_file",120);
print &ui_form_end(@cmdlist);

# end of ui
print "<h3>Command Result:</h3><pre>";
print $in{'setConfig_file'};
print "</pre>";
&ui_print_footer("", $text{'return'});
