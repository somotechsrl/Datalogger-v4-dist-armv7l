#!/usr/bin/perl
# Show Datalogger Status

require 'dlconfig-lib.pl';

# start of ui
ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

# form management
ReadParse();
print &ui_form_start("index.cgi","POST");

# show active interfaces buttons
dlconfig_buttons();

# gets last button/selection	
my $module=%in{"module"};
#$module eq undef || $module=%in{"Drivers"};

# select blocks
#print ui_table_start($text{"dlconfig_dredit"});
#&dataloggerShowSelect(%in{"Brands"},"Brands");
#&dataloggerShowSelect($module,"module");
#&dataloggerDriverParamsOptions($module);
print &ui_table_end();

# chacke module value - if not set exit
$module eq undef && return;

print &ui_form_end();

dlconfig_show($module);

# end of ui
ui_print_footer('/', $text{'index'});

