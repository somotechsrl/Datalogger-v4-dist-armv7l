#!/usr/bin/perl
# Show Datalogger Status
require 'dlbaseconf-lib.pl';

# start of ui
ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

our(%in,$status)
&ReadParseMime();
my $file_data=$in{'setConfig_file'};

if(length $file_data) {
	open my $file, '>', "/tmp/config.tgz" or die $!;
	print $file $file_data;
	close($file);
	$status=`/opt/datalogger/bin/setConfig 2>&1`;
	}

do('setConfig.cgi');
