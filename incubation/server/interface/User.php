<?php

    require_once 'XMLMessage.php';

    class User
    {
        private static $xmlResponse;    
        
        public static function setXMLResponse($xmlResponse)
        {
            User::$xmlResponse = $xmlResponse;
        }
        
        public static function processAction($action)
        {
            if($action == "user_register") {
                if(empty($_POST["username"]) || empty($_POST["password"])) {
                    User::$xmlResponse->sendError("Username or password not specified");
                } else {
                    $username = $_POST['username'];//);
                    $password = $_POST['password'];//); TODO encrypt
                    $firstName = $_POST['firstName'];
                    $lastName = $_POST['lastName'];
                    $userType = $_POST['userType'];
                    $gender = $_POST['gender'];
                    $dateOfBirth = $_POST['dateOfBirth'];
                    $nationality = $_POST['nationality'];
                    $email = $_POST['email'];
                    $dateOfImmigration = $_POST['dateOfImmigration'];
                    $locationLatitude = $_POST['locationLatitude'];
                    $locationLongitude = $_POST['locationLongitude'];
                    
                    User::register($username, $password,$firstName, $lastName, $userType, $gender, $dateOfBirth, $nationality, $email, $dateOfImmigration, $locationLatitude, $locationLongitude);
                }
                return true;
            } else if($action == "user_login") {
                if(empty($_POST["username"]) || empty($_POST["password"])) {
                    User::$xmlResponse->sendError("Username or password not specified");
                } else {
                    //$username = mysql_real_escape_string($_POST['username']);
                    //$password = md5(mysql_real_escape_string($_POST['password']); //TODO encrypt

                    $username = $_POST['username'];
                    $password = $_POST['password'];

                    User::login($username, $password);
                }
                return true;
            } else if($action == "user_logout") {
                User::logout();
                return true;
            } else if($action == "user_logged_in") {
                User::queryLoggedIn();
                return true;
            } else if($action == "user_get_all") {
                User::queryAll();
                return true;
            } else if($action == "user_get_details") {
                if(empty($_POST["user_id"])) {
                    User::$xmlResponse->sendError("User not specified");
                } else {
                    User::queryDetails($_POST['user_id']);
                }
                return true;
            }
            
            return false;
        }
        
        public static function login($username, $password)
        {
            if(!empty($_SESSION['username'])) {
                User::$xmlResponse->sendMessage("User already logged in.");
                return;
            }

            $query = "SELECT * FROM User WHERE Name = '".$username."' AND Password = '".$password."'";
            $checklogin = mysql_query($query);

            if(mysql_num_rows($checklogin) == 1)
            {
                $_SESSION['username'] = $username;

                User::$xmlResponse->sendMessage("Successfully logged in user.");
            }
            else
            {
                User::$xmlResponse->sendError("Invalid username or password.");
            }
        }

        public static function queryLoggedIn()
        {
            if(!empty($_SESSION['username'])) {
                User::$xmlResponse->sendMessage("User logged in.");
                return true;
            }

            User::$xmlResponse->sendError("User not logged in.");

            return false;
        }

        public static function logout()
        {
            $_SESSION = array();
            session_destroy();
            User::$xmlResponse->sendMessage("Sucessfully logged out user");
        }

        public static function queryAll()
        {
            // TODO if logged in
            User::$xmlResponse->addResponse(true);
            $users = User::$xmlResponse->addList("userList");

            $result = mysql_query("SELECT UserID, Name FROM User");

            while($row = mysql_fetch_array($result))
            {
                if(isset($row['UserID']) && isset($row['Name'])) {
                    $user = $users->addList("user");
                    
                    $user->addElement('id', $row['UserID']);
                    $user->addElement('name', $row['Name']);
                }
            }

            User::$xmlResponse->writeOutput();
        }
        
        public static function queryDetails($id) 
        {
            $result = mysql_query("SELECT *, CAST(Immigrant AS unsigned integer) AS ImmigrantUI, CAST(Gender AS unsigned integer) AS GenderUI FROM User WHERE UserID='".$id."'");

            // TODO check #rows == 1
            $row = mysql_fetch_array($result);

            if(isset($row['Name'])) {
                $name = $row['Name'];
                $firstName = $row['FirstName'];
                $lastName = $row['LastName'];
                $userType = $row['ImmigrantUI'];
                $gender = $row['GenderUI'];
                $dateOfBirth = $row['DateOfBirth'];
                $nationality = $row['Nationality'];
                $email = $row['Email'];
                $dateOfImmigration = $row['DateOfImmigration'];
                $locationLatitude = $row['LocationLatitude'];
                $locationLongitude = $row['LocationLongitude'];
                
                User::$xmlResponse->addResponse(true);
                
                $user = User::$xmlResponse->addList("user");

                $user->addElement('UserID', $id);
                $user->addElement('Name', $name);
                $user->addElement('FirstName', $firstName);
                $user->addElement('LastName', $lastName);
                $user->addElement('Immigrant', $userType);
                $user->addElement('Gender', $gender);
                $user->addElement('DateOfBirth', $dateOfBirth);
                $user->addElement('Nationality', $nationality);
                $user->addElement('Email', $email);
                $user->addElement('DateOfImmigration', $dateOfImmigration);
                $user->addElement('LocationLatitude', $locationLatitude);
                $user->addElement('LocationLongitude', $locationLongitude);

                User::$xmlResponse->writeOutput();
            } 
        }
        
        public static function register($username, $password,$firstName, $lastName, $userType, $gender, $dateOfBirth, $nationality, $email, $dateOfImmigration, $locationLatitude, $locationLongitude)
        {
            if(!empty($_SESSION['username'])) {
                User::$xmlResponse->sendMessage("User already logged in.");
                
                return;
            }

            $checkusername = mysql_query("SELECT * FROM User WHERE Name = '".$username."'");

            if(mysql_num_rows($checkusername) == 1)
            {
                User::$xmlResponse->sendError("Username already taken");
            }
            else
            {
                $query = "INSERT INTO User (Name, Password, FirstName, LastName, Immigrant, Gender, DateOfBirth, Nationality, Email, DateOfImmigration, LocationLatitude, LocationLongitude) VALUES('".$username."', '".$password."', '".$firstName."', '".$lastName."', ".$userType.", ".$gender.", '".$dateOfBirth."', '".$nationality."', '".$email."', '".$dateOfImmigration."', '".$locationLatitude."', '".$locationLongitude."')";
                $registerquery = mysql_query($query);
                if($registerquery)
                {
                    User::$xmlResponse->sendMessage("User ".$username." successfully created");
                }
                else
                {
                    echo mysqli_errno();
                    User::$xmlResponse->sendError("Failed to register user");
                }
            }  
        }        
    }

?>
