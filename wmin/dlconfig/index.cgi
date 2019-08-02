#!/usr/bin/perl
# Show Datalogger Status

require 'dlconfig-lib.pl';


ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

dlconfigdb_buttons();
dlconfigdb_show();

ui_print_footer('/', $text{'index'});

