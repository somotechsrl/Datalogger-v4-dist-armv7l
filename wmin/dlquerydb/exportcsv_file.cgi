#!/usr/bin/perl

# Local library
require 'dlquerydb-lib.pl';

# reads submitted data
ReadParse();
$mdate=$in{"dt"};
$module=$in{"em"};

# subdir
$mmonth=$in{"dt"};
$mmonth=~ s/[-][0-9][0-9]$//g;
 
# called from poup
print "Content-type: text/csv\n";
print "Content-disposition: attachment;filename=\"$module-$mdate.csv\";\n";
print "\n";
print `grep -v "^form" /opt/datalogger/www/exports/$module/$mmonth/$mdate.csv`;
