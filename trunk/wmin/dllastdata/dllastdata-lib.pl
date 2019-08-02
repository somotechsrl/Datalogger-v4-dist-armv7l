#!/usr/bin/perl

use WebminCore;
init_config();

sub  dllastdata_buttons {
	my $fn,@fl,$button_desc;
	$fn=`ls /tmp | grep .last`;
	$fn =~ s/[.].*//g;
	@fl = split(/[ \t\n\r]/,$fn);	
	
	#print @fl;
	print ui_form_start("index.cgi","post");
	print ui_buttons_start();
	foreach my $button_name (@fl) {
		#print $button_name;
		$button_desc=`/opt/datalogger/api/iifAltDescr $button_name`;
		print ui_submit($button_desc ne '' ? $button_desc : $button_name,$button_name,0,"value=1 style='max-width: 20em;width: 20em;'");
		}
	print ui_buttons_hr();
	print ui_buttons_end();
	print ui_form_end();
	}

# Raw data format - best to specilize
sub dllastdata_show {

	# loads submit parameters and connects to api - gets CSV format
	ReadParse();
	my @pressed=keys %in;

	# DL API queries
	#my $bdescr=$text{@pressed[0]} ne '' ? $text{@pressed[0]} : @pressed[0];
	my $bdescr=`/opt/datalogger/api/iifAltDescr @pressed[0]`;
	my $filedata=`/opt/datalogger/api/iifLast @pressed[0]`;
	my $filestat=`stat /tmp/@pressed[0].last`;
	
	# Header and some file statistics
	print &ui_table_start($text{'dllastdata_drdata'}.": ".$bdescr);
	print "<pre>$filestat</pre>";
	print &ui_table_end(); 
	
	# check if is a 'CSV' data file or flat
	print &ui_table_start($text{'dllastdata_result'}.": ".$bdescr);
	if(! ($filedata =~ /^head[|]/ ||  $filedata =~ /^data/) ) {
		print "<pre>$filedata</pre>"; 
		print &ui_table_end(); 
		return;
		}

	# this is a CSV with '|' as separator - first line is 'head'
	my @data,@head,@type;	

	# extracts data from textfile
	foreach my $line (split /\n/,$filedata) {

		# extracts row head and nr
		my @row=split /[|]/, $line;
		my $typ=shift @row;

		# creates array(s)
		if($typ eq "head") {
			push(@head,@row);
			}
		if($typ eq "data") {
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
	print ui_form_columns_table(
		undef,
		undef,
		0,
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

