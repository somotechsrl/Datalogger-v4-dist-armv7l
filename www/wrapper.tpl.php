<?
	$scrpt=$_GET["s"];
	$descr=$_GET["d"];

	// checks local php
	if(file_exists("$scrpt.php")) {
		header("Location: /$scrpt.php");
		return;
		}
		
	// commands wich require password/confirm
	$haspassword=array("setvpn","setlan","setdate","reboot","configDL","showTarget","svnupdate");
	$mustconfirm=array("reboot","svnupdate","setdate");	

	# checks password if needed
	if(in_array($scrpt,$haspassword)) include("password.php");
	
?> 
<html>
<head>
	<link rel="stylesheet" href="styles.css"/>
</head>
<body>
<h2><?= $descr ?></h2>
<p class='content'>
<form method='POST'>
<? 
	if(!isset($_POST["confirm"]) && in_array($scrpt,$mustconfirm)) {
		echo "<input type='submit' name='confirm' value='Conferma $descr'>";
		}
	else {
		$params="";
		foreach($_POST as $k => $v) $params.=sprintf("%s='%s' ",$k,$v);
		system("sudo $params /opt/datalogger/scripts/$scrpt");
		}
?>
</form>
</p>
</body>
</html>
