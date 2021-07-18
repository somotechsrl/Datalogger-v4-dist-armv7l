#!/usr/bin/perl
# Show Datalogger Status
require 'dlbaseconf-lib.pl';

# start of ui
ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

our(%in)
&ReadParseMime();
$status={'setConfig_file'};

do('setConfig.cgi');
