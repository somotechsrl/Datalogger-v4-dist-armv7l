#!/usr/bin/perl
# Show all Foobar webserver websites

use 'foobar-lib';

ui_print_header(undef, $module_info{'desc'}, "", undef, 1, 1);

#print "<select name=test><option value=1>uno</option><option value=2>due</option></select>";

#print "<iframe src='http://localhost'></iframe>";
#print "<form method='POST'>";
#print `/opt/datalogger/app/brand`;
#print `brand=contrel /opt/datalogger/app/driver`;
#print "</form>";
#my @test=(1,2,3,4,5);
#ui_select("prova",1,@test);

# Build table contents
my @sites = list_foobar_websites();
my @table = ( );
foreach my $s (@sites) {
	push(@table, [ "<a href='edit.cgi?domain=".urlize($s->{'domain'}).
		       "'>".html_escape($s->{'domain'})."</a>",
		       html_escape($s->{'directory'})
		     ]);
	}

# Show the table with add links
print ui_form_columns_table(
	undef,
	undef,
	0,
	[ [ 'edit.cgi?new=1', $text{'index_add'} ] ],
	undef,
	[ $text{'index_domain'}, $text{'index_directory'} ],
	100,
	\@table,
	undef,
	0,
	undef,
	$text{'index_none'},
	);

system("ls");
ui_print_footer('/', $text{'index'});
