#!/usr/bin/perl
# Show Datalogger Status

require 'dlbaseconf-lib.pl';

# start of ui
ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

ReadParse();

# work variables
my $command, my $module;

# command to exec
if($in{"command"} ne "") {
	$command=$in{"command"};
	}

# Button pressed
my $bdescr=$in{"moduleSubmitActive"};
if($bdescr ne "") {
	$module=getModuleByAltDescr($bdescr);
	}
# select pressed
elsif($in{"moduleSelectAll"} ne "") {
	$module=$in{"moduleSelectAll"};
	}

# Creates new config - here to update correctly buttons.
if($command eq $text{"create_config"}) {
	print &enable_module($module);
	}
elsif($command eq $text{"delete_config"}) {
	print &disable_module($module);
	}

print $command,$module;

# sets form management
print &ui_form_start('dractivate.cgi',"POST");

# Active Modules
print &ui_table_start($text{"active"});
print &dataloggerVarHtml("moduleSelectAll",$module);	
print &dataloggerVarHtml("moduleSubmitActive",$module);	
print &ui_table_end();

# default
my @cmdlist= [
	[ "command" , $text{"create_config"} ],
	[ "command" , $text{"delete_config"} ]
	];

# saves last command for re-usage
print &ui_hidden("module",$module);
print &ui_form_end(@cmdlist);

# end of ui
&ui_print_footer("", $text{'return'});
