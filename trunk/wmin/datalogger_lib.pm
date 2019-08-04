# Converts CSV table to Columns Table Webmin
# # Doesn't se ui_table_start, ui_table end
sub csv2uiColumns {

	my ($title,$filedata) = @_;

	# this is a CSV with '|' as separator - first line is 'head'
	my @data,@head,@type;	

	# extracts data from textfile
	foreach my $line (split /\n/,$filedata) {

		# extracts row head and nr
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

	# normalized head (language table)
	my @nhead;
	foreach $f (@head) {push(@nhead,$text{$f} ne '' ? $text{$f} : $f);}

	print &ui_table_start($title);
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
	# table end
	print &ui_table_end();
	}


return 1;
exit;
