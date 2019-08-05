# define datalogger global path
$DLPACKAGE="/opt/datalogger";
$DLBWIDTH="width=16em;min-width: 16em;";

#========================================================================
# Generates Submit Buttons for Enabled Drivers
#========================================================================
sub  dataloggerShowSubmitModule {

	my ($title) = @_;

	my $fn,@fl,$button_desc;
	$fn=`ls $DLPACKAGE/etc/iif.d`;
	@fl = split(/[ \t\n\r]/,$fn);	
	
	print &ui_form_start("index.cgi","post");
	print &ui_table_start($title);
	print &ui_buttons_start();
	foreach my $button_name (@fl) {
		#print $button_name;
		$button_desc=`/opt/datalogger/api/iifAltDescr $button_name`;
		print &ui_submit($button_desc ne '' ? $button_desc : $button_name,$button_name,0,"value=1 style='$DLBWIDTH'");
		}
	print &ui_buttons_end();
	print &ui_table_end();
	print &ui_form_end();
	}


#========================================================================
# Returns submit button form modules
#========================================================================
sub dataloggerReadSubmitModule {

	# loads submit parameters and connects to api - gets CSV format
	&ReadParse();
	my @pressed=keys %in;

	# selected module
	my $module=@pressed[0];

	if($module eq "") {
		print &ui_table_start($text{'dllastdata_nomodule'});
		print &ui_table_end();
		return undef;
		}

	return $module;
	}

#========================================================================
# Converts CSV table to Columns Table Webmin
#========================================================================
sub dataloggerCsvOut {

	my ($filedata) = @_;

	# this is a CSV with '|' as separator - first line is 'head'
	my @data,@head,@type;	

	# extracts data from textfile
	foreach my $line (split /\n/,$filedata) {

		# extracts row head and nr
		# standard CSV received by API is:
		# 	 separated by '|' 
		# 	 with head/data prefix
		my @row=split /[|]/, $line;
		my $typ=shift @row;

		# creates array(s)
		if($typ eq "head" && ! $head_done) {
			@head=@row;
			}
		if($typ eq "data") {
			push(@data,[ @row ]);
			}
		}

	# normalized head (from webmin language table, if any)
	my @nhead;
	foreach $f (@head) {push(@nhead,$text{$f} ne '' ? $text{$f} : $f);}

	# Show the table with add links
	print &ui_form_columns_table(
		undef,
		undef,
		0,
		undef,
		undef,
		\@nhead,
		100,
		\@data,
		undef,
		0,
		undef,
		$text{'table_nodata'},
		);
	}


#========================================================================
# Generic data file output - tries to automagically recognize format
#========================================================================
sub dataloggerFileOut {

	my ($title,$filedata) = @_;
	
	# block title
	print &ui_table_start($title);

	# check if is a 'CSV' data file or flat
	# must contain data[|] statements
	if($filedata =~ /[\n]?data[|]/) {
		dataloggerCsvOut($filedata);
	} else {
		print "<pre>$filedata</pre>"; 
		}

	print &ui_table_end(); 
	}

return 1;
exit;
