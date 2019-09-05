#!/usr/bin/perl

# Local library
require 'dlquerydb-lib.pl';

# reads submitted data
ReadParse();
$groups=$in{"gr"};
$module=$in{"em"};
$device=$in{"dd"};
$frdate=$in{"df"};
$todate=$in{"dt"};
 
my $environ="group=$groups";
my $command="db-moduledata '$module' '$device' '$frdate' '$todate' 2>&1";

#print "Content-type: text/plain\n\n";
#print "$environ $command\n";
#return;

# called from poup
print "Content-type: text/csv\n";
print "Content-disposition: attachment;filename=\"$module-$frdate-$todate.csv\";\n";
print "\n";
print dataloggerApiTableCSV($command,$environ);
