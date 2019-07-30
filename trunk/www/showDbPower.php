<html>
<head>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
<form>
<?

	$dbdata="/opt/datalogger/db";
	$scripts="/opt/datalogger/scripts";

	$dbid=isset($_GET["drv"]) ? $_GET["drv"] : "";
	$mbid=isset($_GET["mbid"]) ? $_GET["mbid"] : "";
	$date=isset($_GET["date"]) ? $_GET["date"] : "";

	// gets database modules
	system("sudo $scripts/dbSync");
	system("sudo $scripts/dbDrvSelect $dbid");
	
	// gets Filters 
	if($dbid) {		
		system(sprintf("sudo $scripts/dbDrvSelectID '$dbdata/%s' '%s'",$dbid,$mbid));
		system(sprintf("sudo $scripts/dbDrvSelectDate '$dbdata/%s' '%s'",$dbid,$date));
		}

	// submits form
	echo "<input type=submit value='GO'>";
	
	// exports
	echo "<a class='btn' href='/ExportDbPower.php?drv=$dbid&mbid=$mbid&date=$date'>Export CSV</a>";

	
	// gets filtered data
	if(isset($_GET["drv"])) {		
		system(sprintf("sudo $scripts/dbDrvHtmlPower '$dbdata/%s' '%s' '%s'",$dbid,$mbid,$date));
		}
?>
</form>
</body>
</html>
