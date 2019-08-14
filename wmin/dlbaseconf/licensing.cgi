#!/usr/bin/perl

require 'dlbaseconf-lib.pl';

ReadParse();
#$command=$in{"command"};

	
&ui_print_header(undef, $text{'licensing'}, "", undef, 1, 1);
print %in;
if($command eq $text{"apply_lic"}) {
	print "Not yet enabled";
	}
&show_licensing();
&ui_print_footer("", $text{'return'});

