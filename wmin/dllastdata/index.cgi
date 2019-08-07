#!/usr/bin/perl
# Show Datalogger Status

# Local library
require 'dllastdata-lib.pl';


print &ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

print &ui_form_start("index.cgi","POST");
ReadParse();
dllastdata_buttons();
print &ui_form_end();

dllastdata_show();
print &ui_print_footer('/', $text{'index'});

