#!/usr/bin/perl
# Show Datalogger Status

require 'dllastdata-lib.pl';

ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);
print "<pre>";
print `cd /opt/datalogger-v4;iif/raspi/default/module`;
print "<pre>";
ui_print_footer('/', $text{'index'});
