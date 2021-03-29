<?php
$call=$_GET["call"];
$param=$_GET["param"];
header('Content-Type: application/json');
system("cd ..;bin/RPCWrapper '$call' '$param'");
?>
