#!/usr/bin/perl

# Local library
require 'dlquerydb-lib.pl';

# reads submitted data
ReadParse();

# reads POST/GET 
my $dbmodule=$in{"expmodule"};
my $dbdate=$in{"expmoduledate"};
		
my @cmdlist=[ 
	[ "command" , $text{"apply_dbparams"} ], 
	];

# OK, interactive session
print &ui_print_header(undef, $text{'database'}, "", undef, 1, 1);

# Active Modules
print &ui_form_start("exportcsv.cgi","POST");

print &ui_table_start($text{"dbsaved"});

# green status box
if($dbmodule ne "" and $dbdate ne "") {
	print ui_button("&nbsp;",undef,1,"style='background: green'");
	}
else {
	print ui_button("&nbsp;",undef,1,"style='background: red'");
	}

print &dataloggerVarHtml("expmodule");	
print &dataloggerVarHtml("expmoduledate");

my $encoder = URI::Encode->new({encode_reserved => 0});
my $uc=$encoder->encode($command);
my $ue=$encoder->encode($environ);

print "<br><br>";
# show extract button only if there are data
if($dbmodule ne "" and $dbdate ne "") {
	print ui_submit($text{"apply_dbselect"},"command",undef,undef);
	print ui_button($text{"apply_extractcsv"},'CSV',undef,
		"onClick=window.open('exportcsv_file.cgi?em=$dbmodule&dt=$dbdate')"
		);
	print "<br><br>";
	}

	
print ui_table_end();
print &ui_form_end(@cmdlist);

# extracts data and eventually sends files...
if($in{"command"} eq $text{"apply_dbselect"}) {
	print dataloggerApiCSVShow($dbmodule,$dbdate);
	}

print &ui_print_footer("", $text{'return'});


