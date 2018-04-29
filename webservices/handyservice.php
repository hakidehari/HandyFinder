<?php

//including the db operation file
require_once 'DbOperation.php';
 
$db = new DbOperation();

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    
    $latitude = doubleval($_POST['latitude']);
    $longitude = doubleval($_POST['longitude']);
    
    $handymen = $db->retrieveHandyMen($latitude, $longitude);
    
    if (count($handymen) > 0) {
        $response['handymen'] = $handymen;
        echo json_encode($response);
    } else {
        $response['errorMsg'] = "no handymen found";
        echo json_encode($response);
    }
}



?>