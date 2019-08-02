#!/usr/bin/perl
# Show Datalogger Status

require 'dlstatus-lib.pl';

ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);
my $bdescr=`/opt/datalogger/api/iifAltDescr raspi`;
my $lastdata=`/opt/datalogger/api/iifLast raspi`;
print &ui_table_start($text{'dlstatus_drdata'}.": ".$bdescr);
print "<pre>$lastdata</pre>";
print &ui_table_end();
ui_print_footer('/', $text{'index'});
