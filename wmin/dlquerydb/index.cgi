#!/usr/bin/perl
# index.cgi
# Display a menu of various network screens

require './dlquerydb-lib.pl';

ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

foreach $i ('datalogger', 'lastdata', 'database', 'exportcsv') {
	push(@links, "${i}.cgi");
	push(@titles, $text{${i}});
	push(@icons, "images/${i}.svg");
	}
&icons_table(\@links, \@titles, \@icons, @icons > 4 ? scalar(@icons) : 4);

&ui_print_footer("/", $text{'index'});

