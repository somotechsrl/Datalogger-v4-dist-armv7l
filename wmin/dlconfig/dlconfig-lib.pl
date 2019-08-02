#!/usr/bin/perl

use Switch;
use WebminCore;
init_config();

sub  dlconfigdb_buttons {
	my $fn,@fl,$button_desc;
	$fn=`ls /opt/datalogger/etc/iif.d`;
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

	# DL API queries
	#my $bdescr=$text{@pressed[0]} ne '' ? $text{@pressed[0]} : @pressed[0];
	my $bdescr=`/opt/datalogger/api/iifAltDescr @pressed[0]`;
	my $command='cd /opt/datalogger;api/iifConfig '.@pressed[0].' print';

	# this is a CSV with '|' as separator - first line is 'head'
	my @result=split /\n/ , `$command`;
	my @data,@head,@type;	

	# extracts data from textfile
	foreach my $line (split /\n/,`$command`) {

		# extracts row head and nr
		my @row=split /[|]/, $line;
		my $typ=shift @row;
		my $num=shift(@row);

		# creates array(s)
		if($typ eq "head") {
			push(@head,@row);
			}
		if($typ eq "data") {
			push(@hidd,["nr",$num]);
			push(@data,[ @row ]);
			# check type 'awful...'
			foreach $f (@row) {
				push(@type,$f =~ /^[0-9,.E]+$/ ? 'number' : 'string');
				}
			}
		}


	# normalized head (language table)
	my @nhead;
	foreach $f (@head) {push(@nhead,$text{$f} ne '' ? $text{$f} : $f);}

	# Show the table with add links
	print &ui_table_start($text{'dlconfig_drdata'}.": ".$bdescr);
	print ui_form_columns_table(
		undef,
		[ ui_submit('create'),ui_submit('erase'),ui_submit('save') ],
		1,
		undef,
		undef,
		\@nhead,
		100,
		\@data,
		\@type,
		0,
		undef,
		$text{'dlconfig_nodata'},
		);
	print &ui_table_end();
	}

