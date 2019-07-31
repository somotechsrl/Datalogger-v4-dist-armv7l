#!/usr/bin/perl
# Show Datalogger Status

require 'dlstatus-lib.pl';

ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);
print `/opt/datalogger/api/iifLast raspi`;
ui_print_footer('/', $text{'index'});
