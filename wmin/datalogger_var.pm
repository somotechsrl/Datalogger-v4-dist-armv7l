#========================================================================
# Needed for debug
#========================================================================
#use strict;
use warnings;

use WebminCore;
use Data::Dump;  # use Data::Dumper;

# define datalogger global path
my $DLPACKAGE="/opt/datalogger";
my $DLBWIDTH="width=16em;min-width: 16em;";

#========================================================================
# Gets  Module key by Alt Descr - AWFUL
#========================================================================
sub getModuleByAltDescr($descr) {
	return callDataloggerAPI("iifModuleByAltDescr '$descr'");
	}

#========================================================================
# Generates Submit Buttons for Enabled Drivers
#========================================================================
sub  dataloggerShowSubmitModule {

	my ($name,$disable) = @_;
	
	$fn=`ls $DLPACKAGE/etc/iif.d`;
	@fl = split(/[ \t\n\r]/,$fn);	
	
	my $res=&ui_buttons_start();
	foreach my $button_value (@fl) {
		my $button_descr=`/opt/datalogger/api/iifAltDescr $button_value`;
		$res.=&ui_submit($button_descr,$name,$disable, "style='$DLBWIDTH'");
		}
	$res.=&ui_buttons_end();
	
	return $res;
	}


#========================================================================
# Generates Variable HTML input for  Mapped vars
#========================================================================
sub dataloggerVarHtml {

	my ($name,$value,$disable) = @_;

	# 'pause boxes
	if($name =~ /PAUSE$/) {
		return ui_checkbox($name,"true",undef,$value eq "true");
		}
	if($name =~ /FREQ$/) {
		return ui_textbox($name,$value,5,0,5,"type='number'");
		}
	if($name =~ /DESCR$/) {
		return ui_textbox($name,$value,60,0,60,"type='text'");
		}
	if($name eq "moduleSelectActive") {
		$filedata=callDataloggerAPI("sel-menabled");
		my ($rhead,$rdata)=dataloggerArrayFromCSV($filedata);
		my @head=\@$rhead,my @options=\@$rdata;
		return &ui_select($name,$value,@options,undef,undef,undef,undef,undef);
		}	
	if($name eq "moduleSubmitActive") {
		return &dataloggerShowSubmitModule($name,$disable);
		}	

	if($name eq "moduleSelectAll") {
		$filedata=callDataloggerAPI("sel-module");
		my ($rhead,$rdata)=dataloggerArrayFromCSV($filedata);
		my @head=\@$rhead,my @options=\@$rdata;
		return &ui_select($name,$value,@options,undef,undef,undef,undef,undef);
		}

	if($name eq "schannel" || $name eq "mbserial") {
		$filedata=callDataloggerAPI("sel-mbserial");
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
		$filedata=callDataloggerAPI("sel-mbaddress");
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
	return ui_textbox($name,$value,40,$disable,undef,undef);
	return $selectValue;
	}

