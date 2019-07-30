<?
	$ename=sprintf("export-%d.csv",date("U"));

	header("Content-type: text/csv");			
	header("Content-type: application/force-download"); 
	header("Content-Transfer-Encoding: Binary");   			
	header("Content-Disposition: attachment;filename=\"$ename\"");
	header("Expires: 0");
	header("Cache-Control: must-revalidate");
	header("Pragma: public");	

	$dbdata="/opt/datalogger/db";
	$scripts="/opt/datalogger/scripts";

	$dbid=isset($_GET["drv"]) ? $_GET["drv"] : "";
	$mbid=isset($_GET["mbid"]) ? $_GET["mbid"] : "";
	$date=isset($_GET["date"]) ? $_GET["date"] : "";

	if(isset($_GET["drv"])) {		
		system(sprintf("sudo $scripts/dbDrvCSV '%s' '%s' '%s'",$dbid,$mbid,$date));
		}
?>
