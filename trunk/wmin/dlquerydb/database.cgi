#!/usr/bin/perl

# Local library
require 'dlquerydb-lib.pl';

# reads submitted data
ReadParse();

my @cmdlist=[ 
	[ "command" , $text{"apply_dbparams"} ], 
	[ "command" , $text{"apply_dbselect"} ], 
	[ "command" , $text{"apply_extractcsv"} ], 
	[ "command" , $text{"apply_extractxls"} ], 
	];

print &ui_print_header(undef, $text{'database'}, "", undef, 1, 1);

# Active Modules
print &ui_form_start("database.cgi","POST");
print &ui_table_start($text{"dbsaved"});
print &dataloggerVarHtml("dbquerymodule");	
print &dataloggerVarHtml("dbquerymoduledevice");
print &dataloggerVarHtml("dbquerymodulegroups");	
print &dataloggerVarHtml("dbquerymodulefrdate");	
print &dataloggerVarHtml("dbquerymoduletodate");	
print ui_table_end();
print &ui_form_end(@cmdlist);

# searches command and module -- priority tu submit buttons..
if($in{"command"} eq $text{"apply_dbselect"}) {

	# File statistics
	my $dbmodule=$in{"dbquerymodule"};
	my $dbgroup=$in{"dbquerymodulegroups"};
	my $dbdevice=$in{"dbquerymoduledevice"};
	my $dbfromdate=$in{"dbquerymodulefrdate"};
	my $dbtodate=$in{"dbquerymoduletodate"};
	my $environ="module=$dbmodule group=$dbgroup device=$dbdevice fr_date=$dbfromdate to_date=$dbtodate";
	
	#print "***** $environ *******";
	#print callDataloggerAPP("setDataTables dbajax.cgi",$environ);
	
	# outputs data 
	my $filedata=callDataloggerAPI("db-moduledata '$dbmodule' '$dbdevice' '$dbfromdate' '$dbtodate'","group=$dbgroup");
	&dataloggerCsvOut($filedata);
	}

print &ui_print_footer("", $text{'return'});


