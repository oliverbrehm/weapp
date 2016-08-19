<?php

    class User
    {
        public $id;
        public $name;
        public $firstName;
        public $lastName;
        public $userType;       
        public $gender;
        public $dateOfBirth;
        public $nationality;
        public $email;
        public $dateOfImmigration;
        public $locationLatitude;
        public $locationLongitude;
        
        public function __construct($id, $name, $firstName, $lastName, 
                $userType, $gender, $dateOfBirth, $nationality, $email, 
                $dateOfImmigration, $locationLatitude, $locationLongitude) {
            $this->id = $id;
            $this->name = $name;
            $this->firstName = $firstName;
            $this->lastName = $lastName;
            $this->userType = $userType;       
            $this->gender = $gender;
            $this->dateOfBirth = $dateOfBirth;
            $this->nationality = $nationality;
            $this->email = $email;
            $this->dateOfImmigration = $dateOfImmigration;
            $this->locationLatitude = $locationLatitude;
            $this->locationLongitude = $locationLongitude;
        }
        
        public static function withIDAndName($id, $name) {
            $instance = new self($id, $name, "", "", "", "", "", "", "", "", "", "");
            return $instance;
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

        public static function queryAll() // returns a list of invitations containing id and name
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

                $user = User::withIDAndName($userId, $userName);
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
                
            $userName = "";
            $firstName = "";
            $lastName = "";
            $userType = "";
            $gender = "";
            $dateOfBirth = "";
            $nationality = "";
            $email = "";
            $dateOfImmigration = "";
            $locationLatitude = "";
            $locationLongitude = "";
                
            foreach($userNodes as $userNode) {
                
                $children = $userNode->getElementsByTagName("*");
                foreach($children as $child) {
                    if($child->tagName === "Name") {
                        $userName = $child->textContent;
                    } 
                    if($child->tagName === "FirstName") {
                        $firstName = $child->textContent;
                    } 
                    if($child->tagName === "LastName") {
                        $lastName = $child->textContent;
                    } 
                    if($child->tagName === "Immigrant") {
                        $userType = $child->textContent;
                    } 
                    if($child->tagName === "Gender") {
                        $gender = $child->textContent;
                    } 
                    if($child->tagName === "DateOfBirth") {
                        $dateOfBirth = $child->textContent;
                    } 
                    if($child->tagName === "Nationality") {
                        $nationality = $child->textContent;
                    } 
                    if($child->tagName === "Email") {
                        $email = $child->textContent;
                    } 
                    if($child->tagName === "DateOfImmigration") {
                        $dateOfImmigration = $child->textContent;
                    } 
                    if($child->tagName === "LocationLatitude") {
                        $locationLatitude = $child->textContent;
                    } 
                    if($child->tagName === "LocationLongitude") {
                        $locationLongitude = $child->textContent;
                    } 
                }
    
                $user = new User($userId, $userName, $firstName, $lastName, $userType, $gender, $dateOfBirth, $nationality, $email, $dateOfImmigration, $locationLatitude, $locationLongitude);
                
                // should only be one user so return
                return $user;
            }

            return null;        
        }

        public static function register($username, $password,$firstName, $lastName, $userType, $gender, $dateOfBirth, $nationality, $email, $dateOfImmigration, $locationLatitude, $locationLongitude)
        {
            $data = array('action' => 'user_register'
                    , 'username' => $username
                    , 'password' => $password
                    , 'firstName' => $firstName
                    , 'lastName' => $lastName
                    , 'userType' => $userType
                    , 'gender' => $gender
                    , 'dateOfBirth' => $dateOfBirth
                    , 'nationality' => $nationality
                    , 'email' => $email
                    , 'dateOfImmigration' => $dateOfImmigration
                    , 'locationLatitude' => $locationLatitude
                    , 'locationLongitude' => $locationLongitude);

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