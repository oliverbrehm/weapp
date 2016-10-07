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
                if(empty($_POST["mail"]) || empty($_POST["password"])) {
                    User::$xmlResponse->sendError("Mail or password not specified");
                } else {
                    $mail = $_POST['mail'];
                    $password = $_POST['password'];//); TODO encrypt
                    $firstName = $_POST['firstName'];
                    $lastName = $_POST['lastName'];
                    $userType = $_POST['userType'];
                    $gender = $_POST['gender']; 
                    $dateOfBirth = $_POST['dateOfBirth'];
                    $nationality = $_POST['nationality'];
                    $dateOfImmigration = $_POST['dateOfImmigration'];
                    $locationLatitude = $_POST['locationLatitude'];
                    $locationLongitude = $_POST['locationLongitude'];
                    
                    User::register($mail, $password,$firstName, $lastName, $userType, $gender, $dateOfBirth, $nationality, $dateOfImmigration, $locationLatitude, $locationLongitude);
                }
                return true;
            } else if($action == "user_login") {
                if(empty($_POST["mail"]) || empty($_POST["password"])) {
                    User::$xmlResponse->sendError("Mail or password not specified");
                } else {
                    //$username = mysql_real_escape_string($_POST['username']);
                    //$password = md5(mysql_real_escape_string($_POST['password']); //TODO encrypt

                    $mail = $_POST['mail'];
                    $password = $_POST['password'];

                    User::login($mail, $password);
                }
                return true;
            } else if($action == "user_logout") {
                User::logout();
                return true;
            } else if($action == "user_idLoggedIn") {
                User::queryLoggedIn();
                return true;
            } else if($action == "user_query") {
                User::queryAll();
                return true;
            } else if($action == "user_details") {
                if(empty($_POST["userId"])) {
                    User::$xmlResponse->sendError("User not specified");
                } else {
                    User::queryDetails($_POST['userId']);
                }
                return true;
            }
            
            return false;
        }
        
        public static function login($mail, $password)
        {
            if(!empty($_SESSION['userId'])) {
                User::$xmlResponse->sendMessage("User already logged in.");
                return;
            }

            $query = "SELECT * FROM User WHERE Mail = '".$mail."' AND Password = '".$password."'";
            $checklogin = mysql_query($query);

            if(mysql_num_rows($checklogin) == 1)
            {
                $row = mysql_fetch_array($checklogin);
                $userId = $row['UserID'];
                $_SESSION['userId'] = $userId;

                User::$xmlResponse->addResponse(true);
                $loginNode = User::$xmlResponse->addElement("Login", "Successfully logged in user.");
                $loginNode = User::$xmlResponse->addElement("UserID", $userId);
                User::$xmlResponse->writeOutput();
            }
            else
            {
                User::$xmlResponse->sendError("Invalid mail or password.");
            }
        }

        public static function queryLoggedIn()
        {
            if(!empty($_SESSION['userId'])) {
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

            $result = mysql_query("SELECT UserID, Mail, FirstName, LastName FROM User");

            while($row = mysql_fetch_array($result))
            {
                if(isset($row['UserID']) && isset($row['Name'])) {
                    $user = $users->addList("user");
                    
                    $user->addElement('id', $row['UserID']);
                    $user->addElement('mail', $row['Mail']);
                    $user->addElement('firstName', $row['FirstName']);
                    $user->addElement('lastName', $row['LastName']);
                }
            }

            User::$xmlResponse->writeOutput();
        }
        
        public static function queryDetails($id) 
        {
            if(empty($_SESSION['userId'])) {
                User::$xmlResponse->sendError("User no logged in.");             
                return;
            }
            
            $currentUser = $_SESSION['userId'];
            
            $querySelect = "*";
            if($id != $currentUser) { // diffrent user, query only public details
                $querySelect = "FirstName, LastName, Immigrant, Gender, Nationality, DateOfImmigration";
            }
            
            $result = mysql_query("SELECT ".$querySelect.", CAST(Immigrant AS unsigned integer) AS ImmigrantUI, CAST(Gender AS unsigned integer) AS GenderUI FROM User WHERE UserID='".$id."'");

            // TODO check #rows == 1
            $row = mysql_fetch_array($result); 
            
            $firstName = $row['FirstName'];
            $lastName = $row['LastName'];
            $userType = $row['ImmigrantUI'];
            $gender = $row['GenderUI'];
            $nationality = $row['Nationality'];
            $dateOfImmigration = $row['DateOfImmigration'];

            if($id == $currentUser) {
                $mail = $row['Mail'];
                $dateOfBirth = $row['DateOfBirth'];
                $locationLatitude = $row['LocationLatitude'];
                $locationLongitude = $row['LocationLongitude'];
            }

            User::$xmlResponse->addResponse(true);

            $user = User::$xmlResponse->addList("user");

            $user->addElement('UserID', $id);
            $user->addElement('FirstName', $firstName);
            $user->addElement('LastName', $lastName);
            $user->addElement('Immigrant', $userType);
            $user->addElement('Gender', $gender);
            $user->addElement('Nationality', $nationality);
            $user->addElement('DateOfImmigration', $dateOfImmigration);

            if($id == $currentUser) {
                $user->addElement('Mail', $mail);
                $user->addElement('DateOfBirth', $dateOfBirth);
                $user->addElement('LocationLatitude', $locationLatitude);
                $user->addElement('LocationLongitude', $locationLongitude);  
            }

            User::$xmlResponse->writeOutput();
        }
        
        public static function register($mail, $password,$firstName, $lastName, $userType, $gender, $dateOfBirth, $nationality, $dateOfImmigration, $locationLatitude, $locationLongitude)
        {
            if(!empty($_SESSION['userId'])) {
                User::$xmlResponse->sendMessage("User already logged in.");
                
                return;
            }

            $checkmail = mysql_query("SELECT * FROM User WHERE Mail = '".$mail."'");

            if(mysql_num_rows($checkmail) == 1)
            {
                User::$xmlResponse->sendError("There is already an acount for this mail adress");
            }
            else
            {
                $query = "INSERT INTO User (Mail, Password, FirstName, LastName, Immigrant, Gender, DateOfBirth, Nationality, DateOfImmigration, LocationLatitude, LocationLongitude) VALUES('".$mail."', '".$password."', '".$firstName."', '".$lastName."', ".$userType.", ".$gender.", '".$dateOfBirth."', '".$nationality."', '".$dateOfImmigration."', '".$locationLatitude."', '".$locationLongitude."')";
                $registerquery = mysql_query($query);
                if($registerquery)
                {
                    User::$xmlResponse->sendMessage("User ".$mail." successfully created");
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
