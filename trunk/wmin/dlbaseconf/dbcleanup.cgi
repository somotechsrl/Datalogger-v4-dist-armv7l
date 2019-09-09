#!/usr/bin/perl

# Local library
require 'dlbaseconf-lib.pl';

# reads submitted data
ReadParse();

# reads POST/GET 
my $dbmodule=$in{"dbmodule"};
my $dbdevice=$in{"dbmoduledevice"};
my $dbfrdate=$in{"dbmodulefrdate"};
my $dbtodate=$in{"dbmoduletodate"};
	
my $environ="";
my $tableshow="db-moduledata '$dbmodule' '$dbdevice' '$dbfrdate' '$dbtodate' 2>&1";

my @cmdlist=[ 
	[ "command" , $text{"apply_dbparams"} ], 
	];

# OK, interactive session
print &ui_print_header(undef, $text{'dbcleanup'}, "", undef, 1, 1);


# Active Modules
print &ui_form_start("dbcleanup.cgi","POST");
print &ui_table_start($text{"dbsaved"});


# green status box
if(not (!$dbmodule or !$dbdevice or !$dbfrdate or !$dbtodate)) {
	print ui_button("&nbsp;",undef,1,"style='background: green'");
	}
else {
	print ui_button("&nbsp;",undef,1,"style='background: red'");
	}

print &dataloggerVarHtml("dbmodule");	
print &dataloggerVarHtml("dbmoduledevice");
print &dataloggerVarHtml("dbmodulefrdate");	
print &dataloggerVarHtml("dbmoduletodate");	

print "<br><br>";
# show extract button only if there are data
if(not (!$dbmodule or !$dbdevice or !$dbfrdate or !$dbtodate)) {
	print ui_submit($text{"apply_dbcleanup"},"command",undef,undef);
	print "<br><br>";
	}

my $encoder = URI::Encode->new({encode_reserved => 0});
my $uc=$encoder->encode($command);
my $ue=$encoder->encode($environ);

print ui_table_end();
print &ui_form_end(@cmdlist);

# extracts data and eventually sends files...
if($in{"command"} eq $text{"apply_dbselect"}) {
	print dataloggerApiTableShow($tableshow,$environ);
	}

print &ui_print_footer("", $text{'return'});


