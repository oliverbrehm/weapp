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

                    User::register($username, $password);
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
            } else if($action == "get_users") {
                User::queryAllNames();
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

            $checklogin = mysql_query("SELECT * FROM users WHERE name = '".$username."' AND password = '".$password."'");

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

        public static function queryAllNames()
        {
            $result = mysql_query("SELECT * FROM users");

            $users = new ArrayObject;

            while($row = mysql_fetch_array($result))
            {
                if(isset($row['name'])) {
                    $users->append($row['name']);
                }
            }

            User::$xmlResponse->sendList("userList", "userName", $users);
        }

        public static function register($username, $password)
        {
            if(!empty($_SESSION['username'])) {
                User::$xmlResponse->sendMessage("User already logged in.");
                
                return;
            }

            $checkusername = mysql_query("SELECT * FROM users WHERE name = '".$username."'");

            if(mysql_num_rows($checkusername) == 1)
            {
                User::$xmlResponse->sendError("Username already taken");
            }
            else
            {
                $registerquery = mysql_query("INSERT INTO users (name, password) VALUES('".$username."', '".$password."')");
                if($registerquery)
                {
                    User::$xmlResponse->sendMessage("User ".$username." successfully created");
                }
                else
                {
                    User::$xmlResponse->sendError("Failed to register user");
                }
            }  
        }        
    }

?>
