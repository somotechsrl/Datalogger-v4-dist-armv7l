<?
	include("password.php");
?>
<html>
<head>
	<link rel="stylesheet" href="styles.css"/>
</head>
<body>
</body>
<?
	$params="";
	foreach($_POST as $k => $v) $params.=sprintf("%s='%s' ",$k,$v);
	system("sudo $params /opt/datalogger/scripts/status");
?>
</body>
</html>
