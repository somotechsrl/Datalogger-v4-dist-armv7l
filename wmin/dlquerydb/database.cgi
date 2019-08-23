#!/usr/bin/perl

# Local library
require 'dlquerydb-lib.pl';

# reads submitted data
ReadParse();

# Result POOST vars
my $dbmodule=$in{"dbquerymodule"};
my $dbgroup=$in{"dbquerymodulegroups"};
my $dbdevice=$in{"dbquerymoduledevice"};
my $dbfromdate=$in{"dbquerymodulefrdate"};
my $dbtodate=$in{"dbquerymoduletodate"};

my @cmdlist=[ 
	[ "command" , $text{"apply_dbparams"} ], 
	[ "command" , $text{"apply_dbselect"} ], 
	[ "command" , $text{"apply_extractcsv"} ], 
	[ "command" , $text{"apply_extractxls"} ], 
	];


# Extracts CSV file
if($in{"command"} eq $text{"apply_extractcsv"}) {
	
	# headers
	print "Content-type: text/csv;\n";
	print "Content-Disposition: attachment; filename=\"$dbmodule-$dbfromdate-$dbtodate.csv\"\n\n";

	# outputs data 
	print &callDataloggerAPI("db-moduledata '$dbmodule' '$dbdevice' '$dbfromdate' '$dbtodate'","group=$dbgroup separator=';'");
	
	return 1;
	}

# Extracts XLS file
if($in{"command"} eq $text{"apply_extractxls"}) {
	
	# headers
	print "Content-type: application/vnd.ms-excel;\n";
	print "Content-Disposition: attachment; filename=\"$dbmodule-$dbfromdate-$dbtodate.xls\"\n\n";

	# outputs data 
	print &callDataloggerAPI("db-moduledata '$dbmodule' '$dbdevice' '$dbfromdate' '$dbtodate'","group=$dbgroup separator=';'");
	
	return 1;
	}

# OK, interactive session
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

	my $environ="module=$dbmodule group=$dbgroup device=$dbdevice fr_date=$dbfromdate to_date=$dbtodate";
	
	#print "***** $environ *******";
	#print callDataloggerAPP("setDataTables dbajax.cgi",$environ);
	
	# outputs data 
	my $filedata=callDataloggerAPI("db-moduledata '$dbmodule' '$dbdevice' '$dbfromdate' '$dbtodate'","group=$dbgroup");
	&dataloggerCsvOut($filedata);
	}

print &ui_print_footer("", $text{'return'});


