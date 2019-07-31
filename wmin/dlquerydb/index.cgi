#!/usr/bin/perl
# Show Datalogger Status

require 'dlquerydb-lib.pl';


ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

dlquerydb_buttons();
dlquerydb_show();

ui_print_footer('/', $text{'index'});

