<?php
$port = '10000';
header('Location: '
    . 'https://'
    . $_SERVER['HTTP_HOST'] . ':' . $port
    . $_SERVER['REQUEST_URI']);
?>
