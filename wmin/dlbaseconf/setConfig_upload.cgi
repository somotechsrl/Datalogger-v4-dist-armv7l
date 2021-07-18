#!/usr/bin/perl
# Show Datalogger Status
require 'dlbaseconf-lib.pl';

# start of ui
ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

our(%in)
&ReadParseMime();
$file_data=$in{'setConfig_file'};

my $status;

if(length $file_data) {
	open my $file, '>', "/tmp/config.tgz" or die $!;
	print $file $file_data;
	close($file);
	sstatus=`/opt/datalogger/bin/setconfig`;
	}

do('setConfig.cgi');
