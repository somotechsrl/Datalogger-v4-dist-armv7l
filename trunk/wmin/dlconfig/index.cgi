#!/usr/bin/perl
# index.cgi
# Display a menu of various network screens

require './dlconfig-lib.pl';

ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

foreach $i ('mod_enable', 'mod_config', 'mod_lastdata') {
	push(@links, "${i}.cgi");
	push(@titles, $text{"${i}_title"});
	push(@icons, "images/${i}.gif");
	}
&icons_table(\@links, \@titles, \@icons, @icons > 4 ? scalar(@icons) : 4);

if (defined(&apply_network) && $access{'apply'} && !$zone) {
	# Allow the user to apply the network config
	print &ui_hr();
	print &ui_buttons_start();
	print &ui_buttons_row("apply.cgi", $text{'index_apply'},
			      $text{'index_applydesc'});
	print &ui_buttons_end();
	}

&ui_print_footer("/", $text{'index'});

