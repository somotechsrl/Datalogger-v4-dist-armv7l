#!/usr/bin/perl
# Show Datalogger Status
require 'dlbaseconf-lib.pl';

use IO::Handle;

# start of ui
ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

our(%in)
&ReadParseMime();
$file_data=$in{'setConfig_file'};

if(length $file_data) {
	open my $file, '>', "/tmp/config.tgz" or die $!;
	print $file $file_data;
	sstatus=`/opt/datalogger/bin/setconfig`;
	}

do('setConfig.cgi');
