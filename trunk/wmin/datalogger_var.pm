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

	# autogen environ from POST/GET
	my $environ="";
	foreach $k (keys %in) {
		$environ.=" $k='$in{$k}'"
		}

	return `$environ /opt/datalogger/app/formvar '$name' '$value'`;
	}

return 1;
exit;
