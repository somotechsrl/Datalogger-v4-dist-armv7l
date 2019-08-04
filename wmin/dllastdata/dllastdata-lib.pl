#!/usr/bin/perl

use WebminCore;
init_config();

use datalogger_lib;

sub  dllastdata_buttons {
	my $fn,@fl,$button_desc;
	$fn=`ls /tmp | grep .last`;
	$fn =~ s/[.].*//g;
	@fl = split(/[ \t\n\r]/,$fn);	
	
	#print @fl;
	print ui_form_start("index.cgi","post");
	print &ui_table_start($text{'dllastdata_active'});
	print ui_buttons_start();
	foreach my $button_name (@fl) {
		#print $button_name;
		$button_desc=`/opt/datalogger/api/iifAltDescr $button_name`;
		print ui_submit($button_desc ne '' ? $button_desc : $button_name,$button_name,0,"value=1 style='max-width: 20em;width: 20em;'");
		}
	print ui_buttons_end();
	print &ui_table_end();
	print ui_form_end();
	}

# Raw data format - best to specilize
sub dllastdata_show {

	# loads submit parameters and connects to api - gets CSV format
	ReadParse();
	my @pressed=keys %in;

	# selected module
	my $module=@pressed[0];

	if($module eq "") {
		print &ui_table_start($text{'dllastdata_nomodule'});
		print &ui_table_end();
		return;
		}

	# DL API queries
	#my $bdescr=$text{@pressed[0]} ne '' ? $text{@pressed[0]} : @pressed[0];
	my $bdescr=`/opt/datalogger/api/iifAltDescr $module`;
	my $filedata=`/opt/datalogger/api/iifLast $module`;
	my $filestat=`stat /tmp/@pressed[0].last`;
	
	# Header and some file statistics
	print &ui_table_start($text{'dllastdata_drdata'}.": ".$bdescr);
	print "<pre>$filestat</pre>";
	print &ui_table_end(); 
	
	# check if is a 'CSV' data file or flat
	my $title=$text{'dllastdata_result'}.": ".$bdescr;
	if(($filedata =~ /^head[|]/ ||  $filedata =~ /^data/) ) {
		csv2uiColumns($title,$filedata);
		return;
		}

	# print flat text file
	print &ui_table_start($title);
	print "<pre>$filedata</pre>"; 
	print &ui_table_end(); 
	}

