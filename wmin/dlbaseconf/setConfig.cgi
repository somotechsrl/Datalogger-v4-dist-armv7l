#!/usr/bin/perl
require 'dlbaseconf-lib.pl';

# start of ui
ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);
print &ui_form_start('setConfig_upload.cgi',"form-data");
print ui_upload("setConfig_file",120);
print &ui_form_end(@cmdlist);

# end of ui
print "<h3>Command Result:</h3><pre>";
print $status;
print "</pre>";
