#!/usr/bin/perl
# Show Datalogger Status

use WebminCore;
use Data::Dump;  # use Data::Dumper;
require 'dlbaseconf-lib.pl';

# start of ui
ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

ReadParse();
#dd %in;

# work variables
my $module=$in{"menabled"};
my $command=$in{"command"};

# sets form management
print &ui_form_start('drconfig.cgi',"POST");

# Active Modules
print &ui_table_start($text{"active"});
print &dataloggerVarHtml("menabled",$module);	
print &ui_table_end();

# cleanup garbage (???) module name can be only letters or _-
$module =~ s/[^a-zA-Z0-9-_]//g;

# searches command and module -- priority tu submit buttons..
my $vmod=$in{"moduleSelectActive"};
if($vmod ne "") {
	$module=getModuleByAltDescr($vmod);
	}

# default
my @cmdlist = [
	[ "command", $text{"apply_module"} ], 
	];

$dlparams=&dataloggerApiParams($module);
if($module and $dlparams) {
	@cmdlist=[ 
		[ "command", $text{"apply_module"} ], 
		[ "command" , $text{"create_data"} ], 
		[ "command" , $text{"delete_data"} ] 
		];
	}

# Creates new config - here to update correctly buttons.
if($command eq $text{"save_data"}) {
	&save_module_entry($module);
	&display_module_entry($module);
	}
elsif($command eq $text{"delete_data"}) {
	&delete_module_entry($module);
	&display_module_entry($module);
	}
elsif($command eq $text{"create_data"} or $command eq $text{"apply_refresh"}) {
	&create_module_entry($module);
	@cmdlist=[ 
		[ "command" , $text{"apply_refresh"} ], 
		[ "command" , $text{"save_data"} ], 
		[ "command" , $text{"apply_data"} ]  
		];
	}
# default action
elsif($module ne "")  {
	&display_module_entry($module);
	}
	
# adds 'find' to cmdlist
#print &ui_hidden("module",$module);
print &ui_form_end(@cmdlist);

# end of ui
&ui_print_footer("", $text{'return'});
