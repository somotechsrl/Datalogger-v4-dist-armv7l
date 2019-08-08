#!/usr/bin/perl
# Show Datalogger Status

require 'dlconfig-lib.pl';

# start of ui
ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

dlconfig_show($module);


# end of ui
ui_print_footer('/', $text{'index'});

