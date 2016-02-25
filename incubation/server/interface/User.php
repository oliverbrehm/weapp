<?php

    require_once 'XMLMessage.php';

    class User
    {
        private $xmlResponse;
        
        public function __construct($xmlResponse) {
            $this->xmlResponse = $xmlResponse;
        }
        
        function login($username, $password)
        {
            if(!empty($_SESSION['username'])) {
                $this->xmlResponse->sendMessage("User already logged in.");
                return;
            }

            $checklogin = mysql_query("SELECT * FROM users WHERE name = '".$username."' AND password = '".$password."'");

            if(mysql_num_rows($checklogin) == 1)
            {
                $_SESSION['username'] = $username;

                $this->xmlResponse->sendMessage("Successfully logged in user.");
            }
            else
            {
                $this->xmlResponse->sendError("Invalid username or password.");
            }
        }

        function loggedIn()
        {
            if(!empty($_SESSION['username'])) {
                $this->xmlResponse->sendMessage("User logged in.");
                return true;
            }

            $this->xmlResponse->sendError("User not logged in.");

            return false;
        }

        function logout()
        {
            $_SESSION = array();
            session_destroy();
            $this->xmlResponse->sendMessage("Sucessfully logged out user");
        }

        function retrieveAllIDs()
        {
            $result = mysql_query("SELECT * FROM users");

            $users = "";

            while($row = mysql_fetch_array($result))
            {
                if(isset($row['name'])) {
                    $users = $users.';'.$row['name'];
                }
            }

            $this->xmlResponse->sendMessage($users);
        }

        function register($username, $password)
        {
            if(!empty($_SESSION['username'])) {
                $this->xmlResponse->sendMessage("User already logged in.");
                
                return;
            }

            $checkusername = mysql_query("SELECT * FROM users WHERE name = '".$username."'");

            if(mysql_num_rows($checkusername) == 1)
            {
                $this->xmlResponse->sendError("Username already taken");
            }
            else
            {
                $registerquery = mysql_query("INSERT INTO users (name, password) VALUES('".$username."', '".$password."')");
                if($registerquery)
                {
                    $this->xmlResponse->sendMessage("User ".$username." successfully created");
                }
                else
                {
                    $this->xmlResponse->sendError("Failed to register user");
                }
            }  
        }        
    }

?>
