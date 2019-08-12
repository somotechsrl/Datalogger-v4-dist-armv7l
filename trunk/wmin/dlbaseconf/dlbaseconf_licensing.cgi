#!/usr/bin/perl

require 'dlbaseconf-lib.pl';

ReadParse();
print %in;
#$command=$in{"command"};

if($command eq $text{"dlbaseconf_renew"}) {
	print "Not yet enabled";
	}
	
&ui_print_header(undef, $text{'dlbaseconf_licensing'}, "", undef, 1, 1);
&show_licensing();
&ui_print_footer("", $text{'dlbaseconf_return'});

