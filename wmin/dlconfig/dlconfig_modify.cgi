#!/usr/bin/perl
# Show Datalogger Status

require 'dlconfig-lib.pl';

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
print &ui_form_start('dlconfig_modify.cgi',"POST");

# Active Modules
print &ui_table_start($text{"dlconfig_active"});
print &dataloggerVarHtml("moduleSubmitActive",$module);	
print&ui_table_end();

# default
my @cmdlist;

# Creates new config - here to update correctly buttons.
if($command eq $text{"save_data"}) {
	&dlconfig_save($module);
	}
elsif($command eq $text{"delete_data"}) {
	&dlconfig_delete($module);
	}


if($command eq $text{"modify_data"}) {
	print "Not yet enabled";
	# &dlconfig_modify($module);
	@cmdlist=[ 
		["command" , $text{"save_data"} ], 
		[ "command" , $text{"cancel_data"} ]  
		];
	}

if($command eq $text{"create_data"}) {
	&dlconfig_create($module);
	@cmdlist=[ 
		["command" , $text{"save_data"} ], 
		[ "command" , $text{"cancel_data"} ]  
		];
	}
# default action
elsif($module ne "")  {
	&dlconfig_display($module,);
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
&ui_print_footer("", $text{'dlconfig_return'});
