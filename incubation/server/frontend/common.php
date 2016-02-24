<?php
    if(session_id() == '' || !isset($_SESSION)) {
        session_start();
    }
    
    function send_query($post_data)
    {
        if(isset($_SESSION['interface_cookie'])) {
            // cookie set
            //echo 'old cookie: '.$_SESSION['interface_cookie']."\n\n";
        }
        $url = 'http://vocab-book.com/integrationsprojekt/interface/interface.php';      
        
        // Get cURL resource
        $curl = curl_init();
        
        $cookie = "";
        if(isset($_SESSION['interface_cookie'])) {
             $cookie = $_SESSION['interface_cookie'];
        }
        // Set some options - we are passing in a useragent too here
        curl_setopt_array($curl, array(
                                       CURLOPT_RETURNTRANSFER => 1,
                                       CURLOPT_URL => $url,
                                       CURLOPT_USERAGENT => 'Codular Sample cURL Request',
                                       CURLOPT_POST => 1,
                                       CURLOPT_POSTFIELDS => $post_data,
                                       CURLOPT_HTTPHEADER => array("Cookie: ".$cookie)
                                       ));
        
        // execute request (for pure xml without header)
        $resp = curl_exec($curl);

        // repeat request requiring header information
        curl_setopt($curl, CURLOPT_HEADER, 1);
        $resp_header = curl_exec($curl);
        
        // search and save cookie
        preg_match('/^Set-Cookie:\s*([^\r\n]*)/mi', $resp_header, $cookies);
        
        if(!isset($_SESSION['interface_cookie'])) {
            $_SESSION['interface_cookie'] = $cookies[1];
        }
        // Close request to clear up some resources
        curl_close($curl);
        
        return $resp;
    }
    
    function read_response_message($response)
    {
        $xml = new DOMDocument();
        $xml->loadXML($response);
        
        $response_nodes = $xml->getElementsByTagName("response");
        
        if($response_nodes->length > 0) {
            $response_node = $response_nodes->item(0);
            return $response_node->getAttribute("message");
        }
        
        return "";
    }
    
    function read_response_value($response)
    {
        $xml = new DOMDocument();
        $xml->loadXML($response);
        
        $response_nodes = $xml->getElementsByTagName("response");
        
        if($response_nodes->length > 0) {
            $response_node = $response_nodes->item(0);
            $r = $response_node->getAttribute("success");
            if($r === "true") {
                return true;
            } else {
                return false;
            }
        }
        
        return false;
    }
    
    function user_login($username, $password_cleartext)
    {
        $data = array('action' => 'user_login', 'username' => $username, 'password' => $password_cleartext);
        
        $result = send_query($data);
        
        echo "\n".$result."\n";
        
        return read_response_value($result);
    }
    
    function get_users()
    {
        $data = array('action' => 'get_users');
        
        $result = send_query($data);
        
        $users = read_response_message($result);
        
        return explode(';', $users);
    }
    
    function get_events() 
    {
        $data = array('action' => 'event_get_all');
        
        $result = send_query($data);
        
        $events = read_response_message($result);
                
        return explode(';', $events);        
    }
    
    function event_get_name($id) 
    {
        $data = array('action' => 'event_get_name', 'event_id' => $id);
        
        $result = send_query($data);
                
        $event_name = read_response_message($result);
        
        return $event_name;     
    }
    
    function event_get_user($id) 
    {
        $data = array('action' => 'event_get_user', 'event_id' => $id);
        
        $result = send_query($data);
                
        $event_name = read_response_message($result);
        
        return $event_name;     
    }
    
    function event_get_description($id) 
    {
        $data = array('action' => 'event_get_description', 'event_id' => $id);
        
        $result = send_query($data);
                
        $event_name = read_response_message($result);
        
        return $event_name;     
    }
    
    function event_create($name, $description)
    {
        $data = array('action' => 'event_create', 'event_name' => $name, 'event_description' => $description);
        
        $result = send_query($data);
        
        echo "\n".$result."\n";
        
        return read_response_value($result);
    }
    
    function user_register($username, $password)
    {
        $data = array('action' => 'user_register', 'username' => $username, 'password' => $password);
        
        $result = send_query($data);
        
        echo "\n".$result."\n";
        
        return read_response_value($result);
    }
    
    function user_logged_in() {
        $data = array('action' => 'user_logged_in');
        
        $result = send_query($data);
        
        echo $result;
        
        return read_response_value($result);
    }
    
    function user_logout()
    {
        $data = array('action' => 'user_logout');
        
        $result = send_query($data);
        
        echo $result;
        
        return read_response_value($result);
    }
    
    function say_hello_action()
    {
        $data = array('action' => 'say_hello');
        
        $result = send_query($data);
        
        //echo $result;
        
        return read_response_message($result);
    }
    
?>