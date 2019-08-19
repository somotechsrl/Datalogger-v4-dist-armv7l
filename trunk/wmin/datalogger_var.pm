#========================================================================
# Needed for debug
#========================================================================
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
		$res.=&ui_submit($button_descr,$name,$disable, "style='width:33.33%;min-width: 18em;'");
		}
	$res.=&ui_buttons_end();
	
	return $res;
	}

#========================================================================
# Generates Select  HTML input for standard call
#========================================================================
sub dataloggerApiSelect {
	my ($api,$name,$value,$disabled,$environment) = @_;
	#print "***** $environment ***";
	$filedata=callDataloggerAPI($api,$environment);
	my ($rhead,$rdata)=dataloggerArrayFromCSV($filedata);
	my @head=\@$rhead,my @options=\@$rdata;
	return &ui_select($name,$value,@options,undef,undef,undef,undef,undef);
	#print "******* $name $value";
	#return `/opt/datalogger/app/select $name $value 1>&2`;
	}
	
#========================================================================
# Generates Select  HTML input for standard call
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
	return `/opt/datalogger/app/tableselect sel-$api`;
	#qx(cd /opt/datalogger;api/sel-$api | app/tableselect);
	}

#========================================================================
# Generates API Table  HTML without checkbox select
#========================================================================
sub dataloggerApiTableShow {
	my ($api) = @_;
	return `/opt/datalogger/app/tableshow $api`;
	#qx(cd /opt/datalogger;api/sel-$api | app/tableselect);
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
		return &dataloggerApiSelect("sel-menabled",$name,$value,$disable);
		}	
	if($name eq "moduleSubmitActive") {
		return &dataloggerShowSubmitModule($name,$disable);
		}	

	if($name eq "dbmodule") {
		return &dataloggerApiSelect("sel-module",$name,$value,$disable);
		}
	if($name eq "dbquerymodule") {
		return &dataloggerApiSelect("sel-dbModules",$name,$value,$disable,$module);
		}

	if($name eq "fr_date") {
		return &dataloggerApiSelect("sel-dbModuleFromDate",$name,$value,$disable,$module);
		}

	if($name eq "dbquerymoduledevice") {
		# uses dbmodule as environment
		my $dbmodule=$in{"dbquerymodule"};
		return &dataloggerApiSelect("sel-dbModuleKeys",$name,$value,$disable,"module=$dbmodule");
		}

	if($name eq "dbquerymodulegroups") {
		# uses dbmodule as environment
		my $dbmodule=$in{"dbquerymodule"};
		return &dataloggerApiSelect("sel-modulegroups",$name,$value,$disable,"module=$dbmodule");
		}

	# database query range fields
	if($name =~ /dbquerymodule.*date$/) {
		my $dbmodule=$in{"dbquerymodule"};
		my $dbdevice=$in{"dbquerymoduledevice"};
		my @minmax= split / /,&callDataloggerAPI("get-dbModuleKeyDates","module=$dbmodule device=$dbdevice");
		$mindate=@minmax[0];
		$maxdate=@minmax[1];
		#print "*** $mindate - $maxdate ***" ;
		return `$environ /opt/datalogger/app/datefield '$name' '$value' '$mindate' '$maxdate'`;
		}

	if($name eq "expmode") {
		return &dataloggerApiSelect("sel-expmode",$name,$value,$disable);
		}

	if($name eq "schannel" || $name eq "mbserial") {
		return &dataloggerApiSelect("sel-mbserial",$name,$value,$disable);
		}

	if($name eq "mbchannel") {
		# temporary - we'd like to have a 'composer'
		return ui_textbox($name,$value,40,$disable,undef,undef);
		my $combos;
		$combos=&dataloggerVarHtml("mbtype",$value);
		$combos.=&dataloggerVarHtml("mbserial",$value);
		$combos.=&dataloggerVarHtml("mbspeed",$value);
		$combos.=&dataloggerVarHtml("mbmode",$value);
		return $combos;
		}

	if($name eq "mbtype") {
		return &dataloggerApiSelect("sel-mbtype",$name,$value,$disable);
		}

	if($name eq "mbmode") {
		return &dataloggerApiSelect("sel-mbmode",$name,$value,$disable);
		}

	if($name eq "mbspeed") {
		return &dataloggerApiSelect("sel-mbspeed",$name,$value,$disable);
		}

	if($name eq "mbaddress") {
		return &dataloggerApiSelect("sel-mbaddress",$name,$value,$disable);
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
	return ui_textbox($name,$value,60,$disable,undef,undef);
	return $selectValue;
	}

return 1;
exit;
