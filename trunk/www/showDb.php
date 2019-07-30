
<html>
<head>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
<h2>Visualizzazione/Export Dati</h2>
<form>
<?
	$dbdata="db";
	$scripts="/opt/datalogger/scripts";

	$dbdata=isset($_GET["dbdata"]) ? $_GET["dbdata"] : "db";
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
	if($dbid!="" && $mbid!="" && $date!="")
		echo "<a class='btn' href='/ExportDb.php?dbdata=$dbdata&drv=$dbid&mbid=$mbid&date=$date'>Export CSV</a>";

	echo "<hr>";
	
	// gets filtered data
	if(isset($_GET["drv"])) {
		system(sprintf("sudo $scripts/dbDrvHtml '%s/%s' '%s' '%s'",$dbdata,$dbid,$mbid,$date));
		}
?>
</form>
</body>
</html>
