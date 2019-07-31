#!/usr/bin/perl
# Show Datalogger Status

require 'dllastdata-lib.pl';


ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

dllastdata_buttons();
dllastdata_show();

ui_print_footer('/', $text{'index'});

