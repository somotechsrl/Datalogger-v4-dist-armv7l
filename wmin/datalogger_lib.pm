# Needed for debug
#use strict;
use warnings;

use WebminCore;
use Data::Dump;  # use Data::Dumper;

#========================================================================
# Generates Submit Buttons for Enabled Drivers
#========================================================================
sub  dataloggerShowSubmitModule {

	my ($name,$disable) = @_;
	
	$fn=`ls /opt/datalogger/etc/iif.d`;
	@fl = split(/[ \t\n\r]/,$fn);	
	
	my $res=&ui_buttons_start();
	foreach my $button_value (@fl) {
		my $button_descr=`/opt/datalogger/api/iifAltDescr $button_value`;
		$res.=&ui_submit($button_descr,$name,$disable, "style='width:33.33%;min-width: 12em;'");
		}
	$res.=&ui_buttons_end();
	
	return $res;
	}

#========================================================================
# Generates Select  HTML input for standard call
#========================================================================
sub dataloggerApiSelect {
	my ($name,$value,$disabled,$environment) = @_;
	return `/opt/datalogger/app/select '$name' '$value' '$size' 2>&1`;
	}
	
#========================================================================
# Generates Textbox  HTML input for standard call
#========================================================================
sub dataloggerApiTextbox {
	my ($name,$value,$size,$disabled,$environment) = @_;
	return `/opt/datalogger/app/textbox '$name' '$value' '$size' 2>&1`;
	}

#========================================================================
# Generates Formwar Smart generator HTML input for standard call
#========================================================================
sub dataloggerApiFormvar {
	my ($name,$value,$size,$disabled,$environment) = @_;
	return `/opt/datalogger/app/formvar '$name' '$value' '$size' 2>&1`;
	}
	
#========================================================================
# Gets API Parameters for module
#========================================================================
sub dataloggerApiParams {
	my ($module) = @_;
	my $res=&callDataloggerAPI("iifParams $module");
	$res =~ s/[ \n\r]//g;
	return $res;
	}

#========================================================================
# Generates API Table  HTML with checkbox select
#========================================================================
sub dataloggerApiTableSelect {
	my ($api) = @_;
	return `/opt/datalogger/app/tableselect $api`;
	}

#========================================================================
# Generates API Table  HTML without checkbox select
#========================================================================
sub dataloggerApiTableShow {
	my ($api,$environ) = @_;
	return `$environ /opt/datalogger/app/tableshow $api`;
	}

#========================================================================
# Generates API Table  HTML without checkbox select
#========================================================================
sub dataloggerApiTableDelete {
	my ($api,$environ) = @_;
	return `$environ /opt/datalogger/app/tabledelete $api`;
	}

#========================================================================
# Generates API Table  HTML without checkbox select
#========================================================================
sub dataloggerApiCSVShow {
	my ($module,$date) = @_;
	return `$environ /opt/datalogger/app/csvshow $module $date 2>&1`;
	}

#========================================================================
# Generates API Table CSV without checkbox select
#========================================================================
sub dataloggerApiTableCSV {
	my ($api,$environ) = @_;
	return `$environ /opt/datalogger/app/tablecsv $api`;
	}

#========================================================================
# Generates Variable HTML input for  Mapped vars
#========================================================================
sub dataloggerVarHtml {

	my ($name,$value,$disable,$environ) = @_;

	# if value is not set, tues to read from %in...
	if(!$value) {
		$value=$in{$name};
		}

	# autogen environ from POST/GET
	my $environ="";
	foreach $k (keys %in) {
		$environ.=" $k='$in{$k}'"
		}

	return `$environ /opt/datalogger/app/formvar '$name' '$value'`;
	}


#========================================================================
# Calls API module prefixing values 
# string must scontain API ansd parameters
#========================================================================
sub callDataloggerAPI {
	my ($apicall,$environ) = @_;
	return `$environ /opt/datalogger/api/$apicall 2>&1`;
	}

#========================================================================
# Calls APP module prefixing values 
# string must scontain API ansd parameters
#========================================================================
sub callDataloggerAPP {
	my ($appcall,$environ) = @_;
	return `$environ /opt/datalogger/app/$appcall 2>&1`;
	}

#========================================================================
# Gets  Module key by Alt Descr via API
#========================================================================
sub getModuleByAltDescr() {
	my ($descr) = @_;
	return callDataloggerAPI("iifModuleByAltDescr '$descr'");
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

	# resul array
	my @data;

	# checks if flist is undef -- uses native mnames
	if(!$flist) {
		foreach $fname (keys %fdata) {
			push(@data, [ $text{$fname} ? $text{$fname} : $fname, dataloggerVarHtml($fname,$fdata{$fname},$protect) ]);
			}
		return @data;
		}

	# generates required fields list
	for my $fname (@$flist) {
		my $value=$fdata{$fname};
		push(@data, [ $text{$fname} ? $text{$fname} : $fname, dataloggerVarHtml($fname,$value,$protect) ]);
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
		print ui_textarea("contents","<pre>$filedata</pre>",40,132,"soft",1); 
		}
	else {
		print ui_textarea("contents","<pre>$filedata</pre>",40,132,"soft",1); 
		}

	print &ui_table_end(); 
	}

return 1;
exit;
