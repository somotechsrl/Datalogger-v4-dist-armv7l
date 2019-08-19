#!/usr/bin/perl
# Show Datalogger Status

require 'dlbaseconf-lib.pl';

# default
my @cmdlist= [
	[ "command" , $text{"create_config"} ],
	[ "command" , $text{"delete_config"} ]
	];

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

# Button pressed
my $bdescr=$in{"moduleSubmitActive"};
if($bdescr ne "") {
	print $bdescr;
	$module=getModuleByAltDescr($bdescr);
	}
# select pressed
elsif($in{"dbmodule"} ne "") {
	$module=$in{"dbmodule"};
	}

# Creates new config - here to update correctly buttons.
if($command eq $text{"create_config"}) {
	&enable_module($module);
	}
elsif($command eq $text{"delete_config"}) {
	foreach my $dis (keys %in) {
		if($dis =~ /^row/) {
	       		&disable_module($in{$dis});
			}
		}
	}

print &ui_form_start('dractivate.cgi',"POST");

# Active Modules
print &ui_table_start($text{"active"});
print &dataloggerVarHtml("dbmodule",$module,$text{"apply_module"});	
#print &dataloggerVarHtml("moduleSubmitActive",$module);	
print &ui_table_end();
print &dataloggerApiTableSelect("menabled");

# saves last command for re-usage
#print &ui_hidden("module",$module);
print &ui_form_end(@cmdlist);

# end of ui
&ui_print_footer("", $text{'return'});
