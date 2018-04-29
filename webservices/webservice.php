<?php

//including the db operation file
require_once 'DbOperation.php';
 
$db = new DbOperation();


$response = array();

if($_SERVER['REQUEST_METHOD']=='POST' && $_POST['login'] == "NO"){
 
    //getting values
    $firstName = $_POST['firstName'];
    $lastName = $_POST['lastName'];
    $email = $_POST['email'];
    $state = $_POST['state'];
    $city = $_POST['city'];
    $password = $_POST['password'];
    $zipCode = $_POST['zipCode'];
    $isHMan = $_POST['isHMan'];
    $skills = $_POST['skills'];
    $experience = $_POST['experience'];
    $latitude = doubleval($_POST['latitude']);
    $longitude = doubleval($_POST['longitude']);
 
    //inserting values 
    if($db->register($firstName,$lastName, $email, $state, $city, $password, $zipCode, $isHMan, $skills, $experience, $latitude, $longitude)){
        $response['error']=false;
        $response['message']='successfully registered';
    }else{
 
        $response['error']=true;
        $response['message']='Could not register';
    }
 
}

else if ($_SERVER['REQUEST_METHOD']=='POST' && $_POST['login'] == "YES") {
    
    $email = $_POST['email'];
    $password = $_POST['password'];
    $latitude = doubleval($_POST['latitude']);
    $longitude = doubleval($_POST['longitude']);
    
    if ($db->login($email, $password, $latitude, $longitude)) {
        $info = $_SESSION['info'];
        $response['error'] = false;
        $response['message'] = 'login successful';
        $response['firstName'] = $info['firstName'];
        $response['lastName'] = $info['lastName'];
        $response['email'] = $info['email'];
        $response['state'] = $info['state'];
        $response['city'] = $info['city'];
        $response['isHMan'] = $info['isHMan'];
        $response['zipCode'] = $info['zipCode'];
        $response['experience'] = $info['experience'];
        $response['skills'] = $info['skills'];
    } else {
        $response['error'] = true;
        $response['message'] = 'could not login';
    }
    
}

else{
    $response['error']=true;
    $response['message']='You are not authorized';
}
echo json_encode($response);


?>