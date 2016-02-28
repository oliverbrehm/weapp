<?php

    class User
    {
        public $id;
        public $name;
        
        public function __construct($id, $name) {
            $this->id = $id;
            $this->name = $name;
        }
    }
    
    class UserQuery
    {

        public static function login($username, $password_cleartext)
        {
            $data = array('action' => 'user_login', 'username' => $username, 'password' => $password_cleartext);

            $request = new PostRequest($data);
            $request->execute();

            return $request->responseValue;
        }

        public static function queryAll() // returns a list of events containing id and name
        {
            $data = array('action' => 'user_get_all');

            $request = new PostRequest($data);
            $request->execute();
            
            $users = new ArrayObject;
            
            $xml = new DOMDocument();
            $xml->loadXML($request->response);

            // api sends id and name
            $userNodes = $xml->getElementsByTagName("user");

            foreach($userNodes as $userNode) {
                
                $children = $userNode->getElementsByTagName("*");
                
                foreach($children as $child) {
                    if($child->tagName === "id") {
                        $userId = $child->textContent;
                    } else if($child->tagName === "name") {
                        $userName = $child->textContent;
                    }
                }

                $user = new User($userId, $userName);
                $users->append($user);
            }

            return $users;
        }
        
        public static function queryDetails($userId)
        {
            $data = array('action' => 'user_get_details', 'user_id' => $userId);

            $request = new PostRequest($data);
            $request->execute();
                                            
            $xml = new DOMDocument();
            $xml->loadXML($request->response);
            
            $userNodes = $xml->getElementsByTagName("user");
                
            foreach($userNodes as $userNode) {
                
                $children = $userNode->getElementsByTagName("*");
                foreach($children as $child) {
                    if($child->tagName === "name") {
                        $userName = $child->textContent;
                    } 
                }

                $user = new User($userId, $userName);
                
                // should only be one user so return
                return $user;
            }

            return null;        }

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