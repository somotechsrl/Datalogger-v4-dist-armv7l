#!/usr/bin/perl

# Local library
require 'dlbaseconf-lib.pl';

# reads submitted data
ReadParse();

my @cmdlist=[ 
	[ "command" , $text{"apply_dbcleanup"} ], 
	];

# OK, interactive session
print &ui_print_header(undef, $text{'dbcleanup'}, "", undef, 1, 1);


# Active Modules
print &ui_form_start("dbcleanup.cgi","POST");
print &ui_table_start($text{"dbcleanup"});
print "<h2 style='color:red;'>".$text{"dbcleanup_warn"}."</h2>";
print ui_table_end();
print &ui_form_end(@cmdlist);

# extracts data and eventually sends files...
if($in{"command"} eq $text{"apply_dbcleanup"}) {
	print callDataloggerAPI("db-cleanup",undef);
	}

print &ui_print_footer("", $text{'return'});


