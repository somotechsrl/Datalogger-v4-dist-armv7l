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
print &dataloggerVarHtml("expmodule");	
print &dataloggerVarHtml("expmoduledate");

my $encoder = URI::Encode->new({encode_reserved => 0});
my $uc=$encoder->encode($command);
my $ue=$encoder->encode($environ);

if($dbmodule ne "" and $dbdate ne "") {
	print ui_button('Download CSV','CSV',undef,"onClick=window.open('exportcsv_file.cgi?em=$dbmodule&dt=$dbdate')");
	}
print ui_table_end();
print &ui_form_end(@cmdlist);

# extracts data and eventually sends files...
if($in{"command"} eq $text{"apply_dbselect"}) {
	print dataloggerApiTableShow($command,$environ);
	}

print &ui_print_footer("", $text{'return'});


