#!/usr/bin/perl

require 'dlbaseconf-lib.pl';

ReadParse();
&ui_print_header(undef, $text{'dlbaseconf_working'}, "", undef, 1, 1);
&save_polldata();
&show_polldata();
&ui_print_footer("", $text{'dlbaseconf_return'});

