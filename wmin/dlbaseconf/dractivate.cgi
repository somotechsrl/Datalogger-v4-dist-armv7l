#!/usr/bin/perl
# Show Datalogger Status

require 'dlbaseconf-lib.pl';

# start of ui
ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

ReadParse();
#dd %in;

# work variables
my $command, my $module;

my $bdescr=$in{"moduleSubmitActive"};

# Button pressed
if($bdescr ne "") {
	$module=getModuleByAltDescr($bdescr);
	}
# select pressed
if($module -eq "" && $in{"moduleSelectAll"} ne "") {
	$module=$in{"moduleSelectAll"};
	}
if($in{"command"} ne "") {
	$command=$in{"command"};
	}

# Creates new config - here to update correctly buttons.
if($command eq $text{"create_config"}) {
	print &dlbaseconf_enable($module);
	}
elsif($command eq $text{"delete_config"}) {
	print &dlbaseconf_disable($module);
	}

# sets form management
print &ui_form_start('dlbaseconf_dractivate.cgi',"POST");

# Active Modules
print &ui_table_start($text{"dlbaseconf_active"});
print &dataloggerVarHtml("moduleSelectAll",$module);	
print &dataloggerVarHtml("moduleSubmitActive",$module);	
print&ui_table_end();

# default
my @cmdlist= [
	[ "command" , $text{"create_config"} ],
	[ "command" , $text{"delete_config"} ]
	];

# saves last command for re-usage
print ui_form_end(@cmdlist);

# end of ui
&ui_print_footer("", $text{'dlbaseconf_return'});
