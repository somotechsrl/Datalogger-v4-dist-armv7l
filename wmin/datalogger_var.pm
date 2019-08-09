# Needed for debug
#use strict;
use warnings;

use WebminCore;
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
	if($name =~ /DESCR$/) {
		return ui_textbox($name,$value,40,0,5,"type='text'");
		}
	if($name eq "moduleSelectActive") {
		$filedata=`$DLPACKAGE/api/sel/mactive`;
		my ($rhead,$rdata)=dataloggerArrayFromCSV($filedata);
		my @head=\@$rhead,my @options=\@$rdata;
		return &ui_select($name,$value,@options,undef,undef,undef,undef,undef);
		}	
	if($name eq "moduleSelectAll") {
		$filedata=`$DLPACKAGE/api/sel/module`;
		my ($rhead,$rdata)=dataloggerArrayFromCSV($filedata);
		my @head=\@$rhead,my @options=\@$rdata;
		return &ui_select($name,$value,@options,undef,undef,undef,undef,undef);
		}

	if($name eq "schannel" || $name eq "mbserial") {
		$filedata=`$DLPACKAGE/api/sel/mbserial`;
		my ($rhead,$rdata)=dataloggerArrayFromCSV($filedata);
		my @head=\@$rhead,my @options=\@$rdata;
		return &ui_select($name,$value,@options,undef,undef,undef,undef,undef);
		}

	if($name eq "mbchannel") {
		my $combos;
		$combos=&dataloggerVarHtml("mbserial",$value);
		$combos.=&dataloggerVarHtml("mbserial",$value);
		$combos.=&dataloggerVarHtml("mbserial",$value);
		return $combos;
		}

	if($name eq "mbaddress") {
		$filedata=`$DLPACKAGE/api/sel/mbaddress`;
		my ($rhead,$rdata)=dataloggerArrayFromCSV($filedata);
		my @head=\@$rhead,my @options=\@$rdata;
		return &ui_select($name,$value,@options,undef,undef,undef,undef,undef);
		}

	if($name eq "mbdelay") {
		if(!$value) {$value=500};
		return ui_textbox($name,$value,5,0,5,"type='number'");
		}

	if($name eq "mboffset") {
		if(!$value) {$value=0};
		return ui_textbox($name,$value,5,0,5,"type='number'");
		}

	if($name =~ "hidden_") {
		@nn=split "_",$name;
		$xname=@nn[1];
		return &ui_hidden($xname,$value);
		}	

		
	# default
	return ui_textbox($name,$value,40,0,undef,undef);
	return $selectValue;
	}

