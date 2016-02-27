<?php
    
    class User
    {

        public static function login($username, $password_cleartext)
        {
            $data = array('action' => 'user_login', 'username' => $username, 'password' => $password_cleartext);

            $request = new PostRequest($data);
            $request->execute();

            return $request->responseValue;
        }

        public static function queryAllNames()
        {
            $data = array('action' => 'get_users');

            $request = new PostRequest($data);
            $request->execute();
            
            $userNames = new ArrayObject;
            
            $xml = new DOMDocument();
            $xml->loadXML($request->response);

            $response_nodes = $xml->getElementsByTagName("id");

            foreach($response_nodes as $node) {
                $userNames->append($node->textContent);
            }

            return $userNames;
        }

        public static function register($username, $password)
        {
            $data = array('action' => 'user_register', 'username' => $username, 'password' => $password);

            $request = new PostRequest($data);
            $request->execute();

            return $request->responseValue;
        }

        public static function queryLoggedIn() {
            $data = array('action' => 'user_logged_in');

            $request = new PostRequest($data);
            $request->execute();

            return $request->responseValue;
        }

        public static function logout()
        {
            $data = array('action' => 'user_logout');

            $request = new PostRequest($data);
            $request->execute();

            return $request->responseValue;
        }
    }
?>