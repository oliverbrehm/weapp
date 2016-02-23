<?php

    function initialize()
    {
        $dbhost = "rdbms.strato.de";
        $dbname = "DB2437647";
        $dbuser = "U2437647";
        $dbpass = "int-testDB0";
        
        mysql_connect($dbhost, $dbuser, $dbpass) or die("MySQL Error: " . mysql_error());
        $database = mysql_select_db($dbname) or die("MySQL Error: " . mysql_error());
        
        //$rows = mysql_query("SELECT * FROM users");
        //echo('initialize!!!');
    }
    
    function user_login($username, $password)
    {
        if(!empty($_SESSION['username'])) {
            xml_add_response(true, "User already logged in.");
            xml_send();
            return;
        }
        
        initialize();
        
        $checklogin = mysql_query("SELECT * FROM users WHERE name = '".$username."' AND password = '".$password."'");
        
        if(mysql_num_rows($checklogin) == 1)
        {
            $_SESSION['username'] = $username;
            
            xml_add_response(true, "Successfully logged in user");
            xml_send();
        }
        else
        {
            xml_add_response(false, "Invalid username or password");
            xml_send();
        }
    }

    function user_logged_in()
    {
        if(!empty($_SESSION['username'])) {
            xml_add_response(true, "User logged in");
            xml_send();
            return true;
        }
        
        xml_add_response(false, "User not logged in");
        xml_send();
        return false;
    }

    function user_logout()
    {
        $_SESSION = array();
        session_destroy();
        xml_add_response(true, "Sucessfully logged out user");
        xml_send();
    }

    function user_register($username, $password)
    {
        initialize();
        
        $checkusername = mysql_query("SELECT * FROM users WHERE name = '".$username."'");
        
        if(mysql_num_rows($checkusername) == 1)
        {
            xml_add_response(false, "Username already taken");
        }
        else
        {
            $registerquery = mysql_query("INSERT INTO users (name, password) VALUES('".$username."', '".$password."')");
            if($registerquery)
            {
                xml_add_response(true, "User ".$username." successfully created");
            }
            else
            {
                xml_add_response(false, "Failed to register user");
            }
        }
        
        xml_send();
    }

    function say_hello()
    {
        xml_add_response(true, "Hello, world!");
        xml_send();
    }

    function no_action()
    {
        xml_add_response(false, "No action specified");
        xml_send();
    }
    
?>
