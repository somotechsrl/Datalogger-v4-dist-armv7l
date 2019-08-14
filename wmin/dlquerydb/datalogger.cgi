#!/usr/bin/perl
# Show Datalogger Status

require 'dlquerydb-lib.pl';

&ui_print_header(undef, $text{'datalogger'}, "", undef, 1, 1);

my $module='raspi';
my $bdescr=callDataloggerAPI("iifAltDescr $module");
my $filedata=callDataloggerAPI("iifLast $module");

&dataloggerFileOut($text{'datalogger'}.": ".$bdescr,$filedata);

&ui_print_footer("", $text{'return'});
