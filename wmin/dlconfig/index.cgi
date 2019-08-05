#!/usr/bin/perl
# Show Datalogger Status

require 'dlconfig-lib.pl';


ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

dlconfig_buttons();
dlconfig_show();

ui_print_footer('/', $text{'index'});

