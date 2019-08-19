#!/usr/bin/perl

# Local library
require 'dlquerydb-lib.pl';

# reads submitted data
ReadParse();

my @cmdlist=[ 
	[ "command" , $text{"apply_dbparams"} ], 
	[ "command" , $text{"apply_dbselect"} ], 
	];

print &ui_print_header(undef, $text{'database'}, "", undef, 1, 1);
print &ui_form_start("database.cgi","POST");

# Active Modules
print &ui_table_start($text{"dbsaved"});
print &dataloggerVarHtml("dbquerymodule");	
print &dataloggerVarHtml("dbquerymoduledevice");
print &dataloggerVarHtml("dbquerymodulegroups");	
print &dataloggerVarHtml("dbquerymodulefrdate");	
print &dataloggerVarHtml("dbquerymoduletodate");	
print ui_table_end();
print &ui_form_end(@cmdlist);

print &ui_form_end();

# searches command and module -- priority tu submit buttons..
my $bdescr=$in{"command"};
if($in{"command"} eq $text{"apply_dbselect"}) {

	# File statistics
	my $dbmodule=$in{"dbquerymodule"};
	my $dbdevice=$in{"dbquerymoduledevice"};
	my $dbfromdate=$in{"dbquerymodulefrdate"};
	my $dbtodate=$in{"dbquerymoduletodate"};
	
	# outputs data 
	my $filedata=callDataloggerAPI("db-moduledata '$dbmodule' '$dbdevice' '$dbfromdate' '$dbtodate'","group=Tensione");
	#print "<pre>".$filedata."</pre>";
	&dataloggerCsvOut($filedata);
	}

print &ui_print_footer("", $text{'return'});


