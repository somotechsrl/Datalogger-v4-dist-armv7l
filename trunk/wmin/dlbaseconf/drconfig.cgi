#!/usr/bin/perl
# Show Datalogger Status

require 'dlbaseconf-lib.pl';

# start of ui
ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

ReadParse();
#dd %in;

# work variables
my $command, my $module;

# searches command and module -- priority tu submit buttons..
my $vmod=$in{"moduleSubmitActive"};
my $command=$in{"command"};
if($vmod ne "") {
	$module=getModuleByAltDescr($vmod);
	}
elsif($in{"module"} ne "") {
	$module=$in{"module"};
	}
if($in{"command"} ne "") {
	$command=$in{"command"};
	}

# sets form management
print &ui_form_start('drconfig.cgi',"POST");

# Active Modules
print &ui_table_start($text{"active"});
print &dataloggerVarHtml("moduleSubmitActive",$module);	
print&ui_table_end();

# default
my @cmdlist;

# Creates new config - here to update correctly buttons.
if($command eq $text{"save_data"}) {
	&save_module($module);
	}
elsif($command eq $text{"delete_data"}) {
	&delete_module($module);
	}


if($command eq $text{"modify_data"}) {
	print "Not yet enabled";
	# &modify_module($module);
	@cmdlist=[ 
		["command" , $text{"save_data"} ], 
		[ "command" , $text{"cancel_data"} ]  
		];
	}

if($command eq $text{"create_data"}) {
	&create_module($module);
	@cmdlist=[ 
		["command" , $text{"save_data"} ], 
		[ "command" , $text{"cancel_data"} ]  
		];
	}
# default action
elsif($module ne "")  {
	&display_module($module);
	@cmdlist=[ 
		[ "command" , $text{"create_data"} ], 
		[ "command" , $text{"modify_data"} ], 
		[ "command", $text{"delete_data"} ] 
		];
	}


# saves last command for re-usage
print ui_hidden("module",$module);

# adds 'find' to cmdlist
print ui_form_end(@cmdlist);

# end of ui
&ui_print_footer("", $text{'return'});
