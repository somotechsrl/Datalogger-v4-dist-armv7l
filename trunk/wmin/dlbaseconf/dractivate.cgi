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
$command=$in{"command"};
if($in{"moduleSubmitActive"} ne "") {
	my $vmod=$in{"moduleSubmitActive"};
	$module=getModuleByAltDescr($vmod);	
	}
elsif($in{"moduleSelectAll"} ne "") {
	$module=$in{"moduleSelectAll"};
	}
elsif($in{"module"} ne "") {
	$module=$in{"module"};
	}
if($in{"command"} ne "") {
	$command=$in{"command"};
	}

# Creates new config - here to update correctly buttons.
if($command eq $text{"create_config"}) {
	print &enable($module);
	}
elsif($command eq $text{"delete_config"}) {
	print &disable($module);
	}

# sets form management
print &ui_form_start('dractivate.cgi',"POST");

# Active Modules
print &ui_table_start($text{"active"});
print &dataloggerVarHtml("moduleSelectAll",$module);	
print &dataloggerVarHtml("moduleSubmitActive",$module);	
print&ui_table_end();

# default
my @cmdlist= [
	[ "command" , $text{"create_config"} ],
	[ "command" , $text{"delete_config"} ]
	];

# saves last command for re-usage
print ui_hidden("module",$module);
print ui_form_end(@cmdlist);

# end of ui
&ui_print_footer("", $text{'return'});
