# Converts CSV table to Columns Table Webmin
# # Doesn't se ui_table_start, ui_table end
#

# Output CSV data 
sub csvFileOut {

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


# Generic data file output - tries to recognize format
sub dataFileOut {

	my ($title,$filedata) = @_;
	
	# block title
	print &ui_table_start($title);

	# check if is a 'CSV' data file or flat
	# must contain data[|] statements
	if($filedata =~ /[\n]?data[|]/) {
		csvFileOut($filedata);
	} else {
		print "<pre>$filedata</pre>"; 
		}

	print &ui_table_end(); 
	}

return 1;
exit;
