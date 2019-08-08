#!/usr/bin/perl
# Show Datalogger Status

require 'dlconfig-lib.pl';

# start of ui
ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

# form management
ReadParse();
my $module=%in{"module"};

print &ui_form_start("index.cgi","POST");
&dataloggerShowSubmitModule($text{"dlconfig_active"});	

# sow module form
print $module;
print ui_table_start($text{"dlconfig_dredit"});


dlconfig_show($module);
print &ui_table_end();

print &ui_form_end();

# end of ui
ui_print_footer('/', $text{'index'});

