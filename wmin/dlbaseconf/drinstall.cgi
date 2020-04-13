#!/usr/bin/perl
# Show Datalogger Status

require 'dlbaseconf-lib.pl';

# default
my @cmdlist= [
	[ "command" , $text{"apply_config"} ],
	[ "command" , $text{"create_install"} ],
	[ "command" , $text{"delete_uninstall"} ]
	];

# start of ui
ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

ReadParse();
my $module=$in{"module"};
my $command=$in{"command"};

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
print &dataloggerVarHtml("menabled",$module,$text{"apply_module"});	
print &ui_table_end();
print &dataloggerApiTableSelect("mpackages");

# saves last command for re-usage
print &ui_form_end(@cmdlist);

# end of ui
&ui_print_footer("", $text{'return'});
