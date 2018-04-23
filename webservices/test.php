<?php
require_once 'DbOperation.php';
$test = new DbOperation();

echo $test->login("haki_sed@hotmail.com", "balls1234", 37.65432, 50.666666);


?>