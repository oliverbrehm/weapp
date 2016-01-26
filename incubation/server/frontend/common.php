<?php
    function send_query($post_data)
    {
        $url = 'http://vocab-book.com/integrationsprojekt/interface/interface.php';
        
        // use key 'http' even if you send the request to https://...
        $options = array(
                         'http' => array(
                                         'header'=> 'Cookie: ' . $_SERVER['HTTP_COOKIE']."\r\n", // TODO use session cookie
                                         'method'  => 'POST',
                                         'content' => http_build_query($post_data),
                                         ),
                         );
        $context  = stream_context_create($options);
        $result = file_get_contents($url, false, $context);
        if ($result === FALSE) {
            return "http request failed";
        }
        
        return $result;
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
    
    function say_hello_action()
    {
        $data = array('action' => 'say_hello');
        
        $result = send_query($data);
        
        //echo $result;
        
        return read_response_message($result);
    }
    
?>