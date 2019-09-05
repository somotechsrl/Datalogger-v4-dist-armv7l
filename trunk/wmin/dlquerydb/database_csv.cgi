#!/usr/bin/perl

# Local library
require 'dlquerydb-lib.pl';

# reads submitted data
ReadParse();
$command=$in{"command"};
$environ=$in{"environ"};

print "Content-type: text/csv;\n";
print "Content-Disposition: attachment; filename=\"$dbmodule-$dbfromdate-$dbtodate.csv\"\n\n";
print &callDataloggerAPI($command,$environ);
