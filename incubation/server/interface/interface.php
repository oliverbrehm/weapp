<?php
    function xml_response($document, $success, $message = "")
    {
        $node_response = $document->createElement("response");
        $attr_response_value = $document->createAttribute("success");
        $attr_response_value->value = json_encode($success);
        $node_response->appendChild($attr_response_value);
        
        $attr_response_text = $document->createAttribute("message");
        $attr_response_text->value = $message;
        $node_response->appendChild($attr_response_text);
        
        return $node_response;
    }
    
    function initialize()
    {
        $dbhost = "rdbms.strato.de";
        $dbname = "DB2437647";
        $dbuser = "U2437647";
        $dbpass = "int-testDB0";
        
        mysql_connect($dbhost, $dbuser, $dbpass) or die("MySQL Error: " . mysql_error());
        $database = mysql_select_db($dbname) or die("MySQL Error: " . mysql_error());
        
        $rows = mysql_query("SELECT * FROM users");
    }
    
    function user_login($username, $password)
    {
        $xml = new DOMDocument("1.0", "UTF-8");

        if(!empty($_SESSION['username'])) {
            $xml->appendChild(xml_response($xml, true, "User already logged in."));
            echo $xml->saveXML();
            return;
        }
        
        initialize();
        
        $checklogin = mysql_query("SELECT * FROM users WHERE name = '".$username."' AND password = '".$password."'");
        
        if(mysql_num_rows($checklogin) == 1)
        {
            $_SESSION['username'] = $username;
            
            $xml->appendChild(xml_response($xml, true, "Successfully logged in user"));
            echo $xml->saveXML();
        }
        else
        {
            $xml->appendChild(xml_response($xml, false, "Invalid username or password"));
            echo $xml->saveXML();
        }
    }
    
    function user_logged_in()
    {
        $xml = new DOMDocument("1.0", "UTF-8");

        if(!empty($_SESSION['username'])) {
            $xml->appendChild(xml_response($xml, true, "User logged in"));
            echo $xml->saveXML();
            return true;
        }
        
        $xml->appendChild(xml_response($xml, false, "User not logged in"));
        echo $xml->saveXML();
        return false;
    }
    
    function user_logout()
    {
        $xml = new DOMDocument("1.0", "UTF-8");
        $_SESSION = array();
        session_destroy();
        $xml->appendChild(xml_response($xml, true, "Sucessfully logged out user"));
        echo $xml->saveXML();
    }
    
    function user_register($username, $password)
    {
        initialize();
        $xml = new DOMDocument("1.0", "UTF-8");
        
        $checkusername = mysql_query("SELECT * FROM users WHERE name = '".$username."'");
        
        if(mysql_num_rows($checkusername) == 1)
        {
            $xml->appendChild(xml_response($xml, false, "Username already taken"));
        }
        else
        {
            $registerquery = mysql_query("INSERT INTO users (name, password) VALUES('".$username."', '".$password."')");
            if($registerquery)
            {
                $xml->appendChild(xml_response($xml, true, "User ".$username." successfully created"));
            }
            else
            {
                $xml->appendChild(xml_response($xml, false, "Failed to register user"));
            }
        }
        
        echo $xml->saveXML();
    }
    
    function say_hello()
    {
        $xml = new DOMDocument("1.0", "UTF-8");
        $xml->appendChild(xml_response($xml, true, "Hello, world!"));
        echo $xml->saveXML();
    }
    
    function no_action()
    {
        $xml = new DOMDocument("1.0", "UTF-8");
        $xml->appendChild(xml_response($xml, false, "No action specified"));
        echo $xml->saveXML();
    }
    
    function error($message)
    {
        $xml = new DOMDocument("1.0", "UTF-8");
        $xml->appendChild(xml_response($xml, false, "Error: ".$message));
        echo $xml->saveXML();
    }
    
    $action = $_POST["action"];
    
    if(session_id() == '' || !isset($_SESSION)) {
        session_start();
    }

    if($action == "user_register") {
        if(empty($_POST["username"]) || empty($_POST["password"])) {
            error("Username or password not specified");
        } else {
            $username = $_POST['username'];//);
            $password = $_POST['password'];//); TODO encrypt
            
            user_register($username, $password);
        }    } else if($action == "user_login") {
        if(empty($_POST["username"]) || empty($_POST["password"])) {
            error("Username or password not specified");
        } else {
            $username = /*mysql_real_escape_string(*/$_POST['username'];//);
            $password = /*md5(mysql_real_escape_string(*/$_POST['password'];//); TODO encrypt
            
            user_login($username, $password);
        }
    } else if($action == "user_logout") {
        user_logout();
    } else if($action == "user_logged_in") {
        user_logged_in();
    } else if($action == "say_hello") {
        say_hello();
    } else {
        no_action();
    }
?>