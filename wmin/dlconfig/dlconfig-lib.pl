#!/usr/bin/perl

use Switch;
use WebminCore;
init_config();

sub  dlconfigdb_buttons {
	my $fn,@fl,$button_desc;
	$fn=`ls /tmp | grep .last`;
	$fn =~ s/[.].*//g;
	@fl = split(/[ \t\n\r]/,$fn);	
	
	#print @fl;
	print &ui_form_start("index.cgi","post");

	print &ui_table_start($text{'dlconfig_active'});
	foreach my $button_name (@fl) {
		#print $button_name;
		#$button_desc=`/opt/datalogger/api/iifDescr $button_name`;
		my $bdescr=`/opt/datalogger/api/iifAltDescr $button_name`;
		print &ui_submit($bdescr,$button_name,0,'style="min-width: 20em;"');
		}
	print &ui_table_end();
	print &ui_form_end();
	}

# Raw data format - best to specilize
sub dlconfigdb_show {

	# loads submit parameters and connects to api - gets CSV format
	ReadParse();
	my @pressed=keys %in;
	#my $bdescr=$text{@pressed[0]} ne '' ? $text{@pressed[0]} : @pressed[0];
	my $bdescr=`/opt/datalogger/api/iifAltDescr @pressed[0]`;
	my $command='cd /opt/datalogger;api/iifConfig '.@pressed[0].' print';

	# this is a CSV with '|' as separator - first line is 'head'
	my @result=split /\n/ , `$command`;
	
	print &ui_table_start($text{'dlconfig_module_list'}.' ('.$bdescr.')','width="100%"');
	foreach my $line (split /\n/,`$command`) {
		my $copen=0;
		my @row=split /[|]/, $line;
		my $type=shift @row;
		switch($type) {
			case "head"  {$copen++;print &ui_columns_start(@row,100,0,,"prova");}
			case "data"  {$copen++;print &ui_columns_row(@row);}
			}
		$copen && print &ui_columns_end();
		}
	print &ui_table_end('');

	}

