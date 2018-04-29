<?php
$info = array();
 
class DbOperation
{
    private $conn;
 
    //Constructor
    function __construct()
    {
        require_once dirname(__FILE__) . '/Config.php';
        require_once dirname(__FILE__) . '/DbConnect.php';
        // opening db connection
        $db = new DbConnect();
        $this->conn = $db->connect();
    }
 
    //Function to create a new user
    public function register($firstName, $lastName, $email, $state, $city, $password, $zipCode, $isHMan, $skills, $experience, $latitude, $longitude)
    {
        if ($this->checkIfDuplicate($email)) {
            return false;
        }
        
        $password = md5($password);
        $stmt = $this->conn->prepare("INSERT INTO handyman(firstName, lastName, email, state, city, password, zipCode, isHMan, skills, experience, latitude, longitude) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("ssssssssssss", $firstName, $lastName, $email, $state, $city, $password, $zipCode, $isHMan, $skills, $experience, $latitude, $longitude);
        $result = $stmt->execute();
        $stmt->close();
        if ($result) {
            return true;
        } else {
            return false;
        }
    }
    
    public function login($email, $password, $latitude, $longitude) {
        global $info;
        $password1 = md5($password);
        $stmt = $this->conn->prepare("SELECT firstName, lastName, email, state, city, zipCode, isHMan, skills, experience FROM `handyman` WHERE email = ? AND password = ?");
        $stmt->bind_param("ss", $email, $password1);
        $stmt->execute();
        $stmt->bind_result($fName, $lName, $mail, $st, $ci, $zip, $hMan, $skill, $exp);
        while ($stmt->fetch()) {
            $info['firstName'] = $fName;
            $info['lastName'] = $lName;
            $info['email'] = $mail;
            $info['state'] = $st;
            $info['city'] = $ci;
            $info['zipCode'] = $zip;
            $info['isHMan'] = $hMan;
            $info['skills'] = $skill;
            $info['experience'] = $exp;
        }
        $_SESSION['info'] = $info;
        //$stmt->close();
        $stmt->store_result();
        if ($stmt->num_rows > 0) {
            //echo "results acquired";
            $stmt->close();
            $this->insertLocation($email, $password1, $latitude, $longitude);
            return true;
        } else {
            //echo "no results";
            $stmt->close();
            return false;
        }
    }
    
    private function insertLocation($email, $password, $latitude, $longitude) {
        $stmt = $this->conn->prepare("UPDATE `handyman` SET latitude = ?, longitude = ? WHERE email = ? AND password = ?");
        $stmt->bind_param("ddss", $latitude, $longitude, $email, $password);
        $stmt->execute();
        $stmt->close();
    }
    
    
    public function retrieveHandyMen($latitude, $longitude) {
        $handymen = array();
        $isHMan = "YES";
        $stmt = $this->conn->prepare("SELECT firstName, lastName, email, state, city, zipCode, skills, experience, ( 3959 * acos( cos( radians( ?) ) * cos( radians( latitude ) ) * cos( radians( longitude ) - radians(?) ) + sin( radians(?) ) * sin( radians( latitude ) ) ) ) AS distance FROM handyman WHERE isHMan = ? HAVING distance < 50");
        $stmt->bind_param("ddds", $latitude, $longitude, $latitude, $isHMan);
        $stmt->execute();
        $stmt->bind_result($firstName, $lastName, $email, $state, $city, $zipCode, $skills, $experience, $distance);
        while ($stmt->fetch()) {
            $arr = array();
            $arr['firstName'] = $firstName;
            $arr['lastName'] = $lastName;
            $arr['email'] = $email;
            $arr['state'] = $state;
            $arr['city'] = $city;
            $arr['zipCode'] = $zipCode;
            $arr['skills'] = $skills;
            $arr['experience'] = $experience;
            array_push($handymen, $arr);
        }
        
        return $handymen;
        
    } 
    
    private function checkIfDuplicate($email) {
        $stmt = $this->conn->prepare("SELECT email FROM `handyman` WHERE email = ?");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $stmt->store_result();
        if ($stmt->num_rows > 0) {
            $stmt->close();
            return true;
        } else {
            $stmt->close();
            return false;
        }
    }
 
}



?>