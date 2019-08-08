# Needed for debug
#use strict;
use warnings;

use WebminCore;
init_config();

use Data::Dump;  # use Data::Dumper;

# define datalogger global path
my $DLPACKAGE="/opt/datalogger";
my $DLBWIDTH="width=16em;min-width: 16em;";

#========================================================================
# Generates Variable HTML input for  Mapped vars
#========================================================================
sub dataloggerVarHtml {

	my ($name,$value) = @_;

	# 'pause boxes
	if($name =~ /PAUSE$/) {
		return ui_checkbox($name,"true",undef,$value eq "true");
		}
	if($name =~ /FREQ$/) {
		return ui_textbox($name,$value,5,0,5,"type='number'");
		}
	if($name eq "module") {
		$filedata=`$DLPACKAGE/api/sel/module`;
		my ($rhead,$rdata)=dataloggerArrayFromCSV($filedata);
		my @head=\@$rhead,my @options=\@$rdata;
		return &ui_select($name,$value,@options,undef,undef,undef,undef,"onchange='submit()'");
		}

	if($name eq "mbchannel") {
		$filedata=`$DLPACKAGE/api/sel/mbserial`;
		my ($rhead,$rdata)=dataloggerArrayFromCSV($filedata);
		my @head=\@$rhead,my @options=\@$rdata;
		return &ui_select($name,$value,@options,undef,undef,undef,undef,"onchange='submit()'");
		}

	if($name eq "mbaddress") {
		$filedata=`$DLPACKAGE/api/sel/mbaddress`;
		my ($rhead,$rdata)=dataloggerArrayFromCSV($filedata);
		my @head=\@$rhead,my @options=\@$rdata;
		return &ui_select($name,$value,@options,undef,undef,undef,undef,"onchange='submit()'");
		}

	if($name =~ "hidden_") {
		@nn=split "_",$name;
		$xname=@nn[1];
		return &ui_hidden($xname,$value);
		}	

		
	# default
	return ui_textbox($name,$value,undef,0,undef,undef);
	return $selectValue;
	}

#========================================================================
# loads variables from file - returns assoc array with data
# format is compatible with data|name|value format used by display 
#========================================================================
sub dataloggerLoadConfig {

	my ($flist,$filename) = @_;

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
		push(@data, [ $text{$fname} ? $text{$fname} : $fname, $fname, dataloggerVarHtml($fname,$value) ]);
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

	my ($flist,$filename) = @_;

	# loads configyration parameters
	my @data=dataloggerLoadConfig($flist,$filename);

	# Show the table with add links
	print &ui_columns_table(
		undef,
		100,
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
			@head=@row;
			}
		if($typ eq "data") {
			push(@data,[ @row ]);
			}
		}

	#dd \@data;
	
	return (\@head,\@data);
	}

#========================================================================
# Generates Submit Buttons for Enabled Drivers
#========================================================================
sub  dataloggerShowSubmitModule {

	my ($title) = @_;
	
	my $button_name="module";
	my $fn,my @fl,my $button_desc;
	$fn=`ls $DLPACKAGE/etc/iif.d`;
	@fl = split(/[ \t\n\r]/,$fn);	
	
	print &ui_table_start($title);
	print &ui_buttons_start();
	foreach my $button_value (@fl) {
		my $button_descr=`/opt/datalogger/api/iifAltDescr $button_value`;
		print &ui_submit($button_value,"module",0,"value='$button_value' style='$DLBWIDTH'");
		}
	print &ui_buttons_end();
	print &ui_table_end();
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
	my @nhead;
	foreach my $f (@head) {push(@nhead,$text{$f} ne '' ? $text{$f} : $f);}

	# Show the table with add links
	print &ui_columns_table(
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
