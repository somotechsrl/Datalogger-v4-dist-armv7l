#!/usr/bin/perl
# Show Datalogger Status

require 'dlstatus-lib.pl';

&ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

my $module='raspi';
my $bdescr=`/opt/datalogger/api/iifAltDescr raspi`;
my $filedata=`/opt/datalogger/api/iifLast $module`;

&dataloggerFileOut($text{'dlstatus_drdata'}.": ".$bdescr,$filedata);

&ui_print_footer('/', $text{'index'});
