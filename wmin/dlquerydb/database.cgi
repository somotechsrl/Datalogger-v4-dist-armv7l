#!/usr/bin/perl

# Local library
require 'dlquerydb-lib.pl';

# reads submitted data
ReadParse();

print &ui_print_header(undef, $text{'database'}, "", undef, 1, 1);
print &ui_form_start("database.cgi","POST");

# Active Modules
print &ui_table_start($text{"dbsaved"});
print &dataloggerVarHtml("dbquerymodule",$module);	
print &ui_table_end();

print &ui_form_end();

# searches command and module -- priority tu submit buttons..
my $bdescr=$in{"moduleSubmitActive"};
if($bdescr) {

	# File statistics
	my $module=getModuleByAltDescr($bdescr);

	# Prnts file status
	#my $filestat=`stat /tmp/$module.last`;
	#print &ui_table_start($text{'dllastdata_drdata'}.": ".$bdescr);
	#print "<pre>$filestat</pre>";
	#print &ui_table_end(); 

	print `setDataTables.sh`

	# outputs data 
	#my $filedata=callDataloggerAPI("db-moduledata '$module' '*' '\$(date -I)'","group=Potenza");
	#print "<pre>".$filedata."</pre>";
	#&dataloggerCsvOut($filedata);
	}

print &ui_print_footer("", $text{'return'});


