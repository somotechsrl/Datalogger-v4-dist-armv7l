#!/usr/bin/perl
# Show Datalogger Status

require 'dlbaseconf-lib.pl';

# start of ui
ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

ReadParse();
#print %in;

print &ui_form_start('getConfig.cgi',"POST");
# &display_firmware_status();
print ui_button($text{"getConfig"},'CSV',undef,"onClick=window.open('getConfig_file.cgi')");
print &ui_form_end(@cmdlist);

# end of ui
#print "<h3>Command Result:</h3><pre>$status</pre>";
&ui_print_footer("", $text{'return'});
