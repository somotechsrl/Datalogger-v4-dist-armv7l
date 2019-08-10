#!/usr/bin/perl

# Local library
require 'dllastdata-lib.pl';

# reads submitted data
ReadParse();


print &ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);
print &ui_form_start("index.cgi","POST");

# Active Modules
print &ui_table_start($text{"dlconfig_active"});
print &dataloggerVarHtml("moduleSubmitActive",$module);	
print &ui_table_end();

print &ui_form_end();

# searches command and module -- priority tu submit buttons..
my $bdescr=$in{"moduleSubmitActive"};
if(!$bdescr) {
	return;
	}

# File statistics
my $module=getModuleByAltDescr($bdescr);
my $filestat=`stat /tmp/$module.last`;

# Prnts out data
#print &ui_table_start($text{'dllastdata_drdata'}.": ".$bdescr);
#print "<pre>$filestat</pre>";
#print &ui_table_end(); 


# outputs data 
my $filedata=`/opt/datalogger/api/iifLast $module`;
&dataloggerFileOut($text{'dllastdata_result'}.": ".$bdescr,$filedata);

print &ui_print_footer('/', $text{'index'});


