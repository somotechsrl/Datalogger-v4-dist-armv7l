#!/usr/bin/perl

require 'dlbaseconf-lib.pl';

ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

foreach $i ('licensing', 'dlupdate','drupdate','polldata', 'rpcconfig','dractivate', 'drconfig',"getConfig","setConfig") {
	push(@links, "${i}.cgi");
	push(@titles, $text{"${i}"});
	push(@icons, "images/${i}.svg");
	}
&icons_table(\@links, \@titles, \@icons, @icons > 4 ? scalar(@icons) : 4);

&ui_print_footer("/", $text{'index'});

#&show_polldata();
