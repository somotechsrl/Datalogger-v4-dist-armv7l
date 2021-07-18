#!/usr/bin/perl
# Show Datalogger Status
require 'dlbaseconf-lib.pl';

# start of ui
ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

our(%in)
&ReadParseMime();
$file_data=$in{'setConfig_file'};

if(length $file_data) {
	sstatus=`/opt/datalogger/bin/setconfig <<< $file_data`;
	}

do('setConfig.cgi');
