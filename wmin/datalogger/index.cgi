#!/usr/bin/perl
# Show Datalogger Status

ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);
print `cd /opt/datalogger;iif/raspi/default/module'
ui_print_footer('/', $text{'index'});
