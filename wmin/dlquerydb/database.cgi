#!/usr/bin/perl

# Local library
require 'dlquerydb-lib.pl';

# reads submitted data
ReadParse();

# reads POST/GET 
my $dbmodule=$in{"dbmodule"};
my $dbdevice=$in{"dbmoduledevice"};
my $dbfrdate=$in{"dbmodulefrdate"};
my $dbtodate=$in{"dbmoduletodate"};
my $dbgroups=$in{"dbmodulegroups"};
	
my $environ="group=$dbgroups";
my $command="db-moduledata '$dbmodule' '$dbdevice' '$dbfrdate' '$dbtodate' 2>&1";

my @cmdlist=[ 
	[ "command" , $text{"apply_dbparams"} ], 
	[ "command" , $text{"apply_dbselect"} ], 
	#[ "command" , $text{"apply_extractcsv"} ], 
	#[ "command" , $text{"apply_extractxls"} ], 
	];

# OK, interactive session
print &ui_print_header(undef, $text{'database'}, "", undef, 1, 1);

# Active Modules
print &ui_form_start("database.cgi","POST");
print &ui_table_start($text{"dbsaved"});
print &dataloggerVarHtml("dbmodule");	
print &dataloggerVarHtml("dbmoduledevice");
print &dataloggerVarHtml("dbmodulegroups");	
print &dataloggerVarHtml("dbmodulefrdate");	
print &dataloggerVarHtml("dbmoduletodate");	

my $encoder = URI::Encode->new({encode_reserved => 0});
my $uc=$encoder->encode($command);
my $ue=$encoder->encode($environ);

#print $uc,$ue;

print ui_button('Download CSV','CSV',undef,"onClick=window.open('database_csv.cgi?c=$uc&e=$ue')");
print ui_button('Download Excel','XLS',undef,"onClick=alert(\'Excel\')");
print ui_table_end();
print &ui_form_end(@cmdlist);

# extracts data and eventually sends files...
if($in{"command"} eq $text{"apply_dbselect"}) {
	my $filedata=callDataloggerAPI($command,$environ);
	&dataloggerCsvOut($filedata);
	}

print &ui_print_footer("", $text{'return'});


