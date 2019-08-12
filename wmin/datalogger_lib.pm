# Needed for debug
#use strict;
use warnings;

use WebminCore;
use Data::Dump;  # use Data::Dumper;

# define datalogger global path
my $DLBWIDTH="width=16em;min-width: 16em;";

#========================================================================
# Calls API module prefixing values 
# string must scontain API ansd parameters
#========================================================================
sub callDataloggerAPI {
	
	my ($apicall) = @_;
	return `/opt/datalogger/api/$apicall`;
	}

#========================================================================
# loads variables from file - returns assoc array with data
# format is compatible with data|name|value format used by display 
#========================================================================
sub dataloggerLoadConfig {

	my ($flist,$filename,$protect) = @_;

	# reads variable from file
	my %fdata;

	# reads config data in assoc array from file
	open(CONF, $filename);
	while(<CONF>) {
		s/[\'\r\n]//g;
		my ($name, $value) = split(/=/, $_);
		if ($name && $value) {
			$fdata{$name}=$value;
			}
		}
	close(CONF);

	# generates required fields list
	my @data;
	for my $fname (@$flist) {
		my $value=$fdata{$fname};
		push(@data, [ $fname, $text{$fname} ? $text{$fname} : $fname, dataloggerVarHtml($fname,$value,$protect) ]);
		}

	return @data;
	}
	

#========================================================================
# saves ALL variables to file - returns assoc array with data
# format is compatible with data|name|value format used by display 
#========================================================================
sub dataloggerSaveConfig {

	my ($flist,$filename) = @_;

	# reads POST
	ReadParse();

	open(FD,">",$filename) or die $!;

	# generates required fields list
	for my $fname (@$flist) {
		my $value=$in{$fname};
		print FD "$fname='$value'\n";
		}
	close(FD);

	}
	

#========================================================================
# generates html table from Config generic file 
# format name='values in the variable' as must be bbash compliant
#========================================================================
sub dataloggerShowConfig {

	my ($flist,$filename,$protect) = @_;

	# loads configyration parameters
	my @data=dataloggerLoadConfig($flist,$filename,$protect);

	# Show the table with add links
	print &ui_columns_table(
		undef,
		undef,
		\@data,
		undef,
		0,
		undef,
		$text{'table_nodata'},
		);
	}


#========================================================================
# Generates Array from CSV 'standard' datalogger API
#========================================================================
sub  dataloggerArrayFromCSV {

	my ($filedata) = @_;
	my @head,my @data;
	
	#print "<pre>$filedata</pre>";

	# extracts data from textfile
	foreach my $line (split /\n/,$filedata) {

		# extracts row head and nr
		# standard CSV received by API is:
		# 	 separated by '|' 
		# 	 with head/data prefix
		my @row=split /[|]/, $line;
		my $typ=shift @row;

		# creates array(s)
		if($typ eq "head") {
			if(@row[0] eq "n") {
				shift @row;
				unshift @row,"select";
				}
			@head=@row;
			}
		if($typ eq "data") {
			if(@head[0] eq "select") {
				$num=shift @row;
				unshift @row,ui_checkbox("row_$num",$num);
				}
			push(@data,[ @row ]);
			}
		}

	#dd \@data;
	
	return (\@head,\@data);
	}

#========================================================================
# Generates Select  for Enabled Drivers
#========================================================================
sub  dataloggerGetActiveModules {

	my ($title,$disable) = @_;
	
	my $button_name="module";
	my $fn,my @fl,my @sl;
	$fn=`ls /opt/datalogger/etc/iif.d`;
	@fl = split(/[ \t\n\r]/,$fn);	
	
	foreach my $module (@fl) {
		my $description=callDataloggerAPI("iifAltDescr $module");
		push @sl, [ $module, $description ];
		}

	return @sl;
	}


#========================================================================
# Converts CSV table to Columns Table Webmin
#========================================================================
sub dataloggerCsvOut {

	my ($filedata) = @_;

	# this is a CSV with '|' as separator - first line is 'head'
	my ($rhead,$rdata)=dataloggerArrayFromCSV($filedata);
	my @head=@$rhead,my @data=@$rdata;

	# normalized head (from webmin language table, if any)
	my @nhead,@ntype;
	foreach my $f (@head) {push(@nhead,$text{$f} ne '' ? $text{$f} : $f);}

	# Show the table with add links
	print &ui_columns_table(
		\@nhead,
		undef,
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
		&dataloggerCsvOut($filedata);
		}
	# XML/HTML file - to display we must escape <>
	 elsif($filedata =~ /<\?xml/) {
		$filedata =~ s/</\&lt;/g;
		$filedata =~ s/>/\&gt;/g;
		print "<pre>$filedata</pre>"; 
		}
	else {
		print "<pre>$filedata</pre>"; 
		}

	print &ui_table_end(); 
	}

return 1;
exit;
