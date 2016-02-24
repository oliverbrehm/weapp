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
    
    function get_users()
    {
        $result = mysql_query("SELECT * FROM users");
        
        $users = "";
        
        while($row = mysql_fetch_array($result))
        {
            if(isset($row['name'])) {
                $users = $users.';'.$row['name'];
            }
        }
        
        xml_add_response(true, $users);
        xml_send();
    }

    function user_register($username, $password)
    {
        if(!empty($_SESSION['username'])) {
            xml_add_response(true, "User already logged in.");
            xml_send();
            return;
        }
        
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
    
    function event_create($name, $description)
    {
        if(empty($_SESSION['username'])) {
            return;
        }
        
        $checkeventname = mysql_query("SELECT * FROM events WHERE name = '".$name."'");
        
        if(mysql_num_rows($checkeventname) >= 1)
        {
            xml_add_response(false, "Event with the same name exists");
        }
        else
        {
            $result = mysql_query("SELECT id FROM users WHERE name = '".$_SESSION['username']."'");
            $row = mysql_fetch_array($result);
            $user_id = $row['id'];
            $createEventQuery = mysql_query("INSERT INTO events (name, description, owner_id) VALUES('".$name."', '".$description."', '".$user_id."')");
            if($createEventQuery)
            {
                xml_add_response(true, "Event ".$name." successfully created.");
            }
            else
            {
                xml_add_response(false, "Failed to create event.");
            }
        }
        
        xml_send();
    }
    
    // returns a list of event ids ; seperated
    function event_get_all()
    {
        // TODO if logged in
        
        $ids = "";
        
        $result = mysql_query("SELECT * FROM events");
                
        while($row = mysql_fetch_array($result))
        {
            if(isset($row['name'])) {
                if(!empty($ids)) {
                    $ids = $ids.';';
                }
                $ids = $ids.$row['id'];
            }
        }
        
        xml_add_response(true, $ids);
        xml_send();
    }
    
    function event_get_user($id) 
    {
        $result = mysql_query("SELECT owner_id FROM events WHERE id='".$id."'");
                
        // TODO check #rows == 1
        $row = mysql_fetch_array($result);

        if(isset($row['owner_id'])) {
            $owner_id = $row['owner_id'];
            
            // TODO combine 2 sql queries to one
            $result = mysql_query("SELECT name FROM users WHERE id='".$owner_id."'");
            
            // TODO check #rows == 1
            $row = mysql_fetch_array($result);

            if(isset($row['name'])) {
                xml_add_response(true, $row['name']);
                xml_send();
            }
        } else {
            xml_error('Event owner name not found.');
        }
    }
    
    function event_get_description($id)
    {
        $result = mysql_query("SELECT description FROM events WHERE id='".$id."'");
                
        // TODO check #rows == 1
        $row = mysql_fetch_array($result);

        if(isset($row['description'])) {
            xml_add_response(true, $row['description']);
            xml_send();
        } else {
            xml_error('Event description not found.');
        }
    }
    
    function event_get_name($id) {        
        $result = mysql_query("SELECT name FROM events WHERE id='".$id."'");
                
        // TODO check #rows == 1
        $row = mysql_fetch_array($result);

        if(isset($row['name'])) {
            xml_add_response(true, $row['name']);
            xml_send();
        } else {
            xml_error('Event name not found.');
        }
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
