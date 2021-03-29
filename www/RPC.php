<?php
$method=$_GET["method"];
$params=$_GET["params"];
header('Content-Type: application/json');
system("cd ..;bin/RPCWrapper '$method' '$params'");
?>
