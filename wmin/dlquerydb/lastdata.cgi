#!/usr/bin/perl

# Local library
require 'dlquerydb-lib.pl';

# reads submitted data
ReadParse();

print &ui_print_header(undef, $text{'lastdata'}, "", undef, 1, 1);
print &ui_form_start("lastdata.cgi","POST");

# Active Modules
print &ui_table_start($text{"active"});
print &dataloggerShowSubmitModule("moduleSubmitActive");	
print &ui_table_end();

print &ui_form_end();

# searches command and module -- priority tu submit buttons..
my $bdescr=$in{"moduleSubmitActive"};
my $module=getModuleByAltDescr($bdescr);

if($module) {

	# Prnts file status
	#my $filestat=`stat /tmp/$module.last`;
	#print &ui_table_start($text{'dllastdata_drdata'}.": ".$bdescr);
	#print "<pre>$filestat</pre>";
	#print &ui_table_end(); 

	# outputs data 
	my $filedata=callDataloggerAPI("iifLast $module");
	&dataloggerFileOut($text{'lastdata'}.": ".$bdescr,$filedata);
	}

print &ui_print_footer("", $text{'return'});


