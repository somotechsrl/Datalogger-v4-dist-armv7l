<form method='POST'>
<?
	$scrpt=$_GET["s"];
	$descr=$_GET["d"];
	session_start();

	$params="";
	# Clears session vars
	foreach($nosession as $k) unset($_SESSION[$k]);
	# Sets Persistent  session vars
	foreach($_GET as $k => $v) $_SESSION[$k]=$v;
	foreach($_POST as $k => $v) $_SESSION[$k]=$v;
	foreach($_SESSION as $k => $v) $params.=sprintf("%s='%s' ",$k,$v);
	system("sudo $params /opt/datalogger/$scrpt");
	}
?>
</form>
