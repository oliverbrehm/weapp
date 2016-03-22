<?php

    class Invitation
    {
        public $id;
        public $name;
        public $ownerId;
        public $ownerName;
        public $description;      
        public $maxParticipants;
        public $date;
        public $time;
        public $locationCity;
        public $locationStreet;
        public $locationStreetNumber;
        public $locationLatitude;
        public $locationLongitude;
               
        public function __construct($id, $name, $ownerId, $ownerName, $description, $maxParticipants, $date, $time, $locationCity, $locationStreet, $locationStreetNumber, $locationLatitude, $locationLongitude) {
            $this->id = $id;
            $this->name = $name;
            $this->ownerId = $ownerId;
            $this->ownerName = $ownerName;
            $this->description = $description;
            $this->maxParticipants = $maxParticipants;
            $this->date = $date;
            $this->time = $time;
            $this->locationCity = $locationCity;
            $this->locationStreet = $locationStreet;
            $this->locationStreetNumber = $locationStreetNumber;
            $this->locationLatitude = $locationLatitude;
            $this->locationLongitude = $locationLongitude;
        }
        
        public static function withIdAndName($id, $name) 
        {
            $instance = new Invitation($id, $name, "", "", "", "", "", "", "", "", "", "", "");
            return $instance;
        }
    }
    
    class Comment
    {
        public $message;
        public $time;
        public $authorId;
        public $authorName;
        
        public function __construct($message, $authorId, $authorName, $time) {
            $this->message = $message;
            $this->time = $time;
            $this->authorId = $authorId;
            $this->authorName = $authorName;
        }
    }
    
    class InvitationQuery
    {
        public static function queryAll() // returns a list of Invitations containing id and name
        {
            $data = array('action' => 'invitation_get_all');

            $request = new PostRequest($data);
            $request->execute();
            
            $invitations = new ArrayObject;
            
            $xml = new DOMDocument();
            $xml->loadXML($request->response);

            // api sends id and name
            $invitationNodes = $xml->getElementsByTagName("invitation");

            foreach($invitationNodes as $invitationNode) {
                $invitationId = "";//$invitationNode->getElementsByTagName("id")->textContent;                    
                $invitationName = "";//$invitationNode->getElementsByTagName("name")->textContent;                    

                $children = $invitationNode->getElementsByTagName("*");
                foreach($children as $child) {
                    if($child->tagName === "id") {
                        $invitationId = $child->textContent;
                    } else if($child->tagName === "name") {
                        $invitationName = $child->textContent;
                    }
                }

                $invitation = Invitation::withIdAndName($invitationId, $invitationName);
                $invitations->append($invitation);
            }

            return $invitations;
        }

        public static function queryByUser($user_id) // returns a list of invitations containing id and name
        {
            $data = array('action' => 'invitation_get_user', 'user_id' => $user_id);

            $request = new PostRequest($data);
            $request->execute();
            
            $invitations = new ArrayObject;
            
            $xml = new DOMDocument();
            $xml->loadXML($request->response);

            // api sends id and name
            $invitationNodes = $xml->getElementsByTagName("invitation");

            foreach($invitationNodes as $invitationNode) {
                $invitationId = "";//$invitationNode->getElementsByTagName("id")->textContent;                    
                $invitationName = "";//$invitationNode->getElementsByTagName("name")->textContent;                    

                $children = $invitationNode->getElementsByTagName("*");
                foreach($children as $child) {
                    if($child->tagName === "id") {
                        $invitationId = $child->textContent;
                    } else if($child->tagName === "name") {
                        $invitationName = $child->textContent;
                    }
                }

                $invitation = Invitation::withIdAndName($invitationId, $invitationName);
                $invitations->append($invitation);
            }

            return $invitations;
        }
        
        public static function queryDetails($id) 
        {
            $data = array('action' => 'invitation_get_details', 'id' => $id);

            $request = new PostRequest($data);
            $request->execute();
                                    
            $xml = new DOMDocument();
            $xml->loadXML($request->response);

            $invitationNodes = $xml->getElementsByTagName("invitation");
            
            $name = "";
            $ownerId = "";
            $ownerName = "";
            $description = "";
            $maxParticipants = "";
            $date = "";
            $time = "";
            $locationCity = "";
            $locationStreet = "";
            $locationStreetNumber = "";
            $locationLatitude = "";
            $locationLongitude = "";
                
            foreach($invitationNodes as $invitationNode) {
                
                $children = $invitationNode->getElementsByTagName("*");
                foreach($children as $child) {
                    if($child->tagName === "Name") {
                        $name = $child->textContent;
                    } else if($child->tagName === "OwnerId") {
                        $ownerId = $child->textContent;
                    } else if($child->tagName === "OwnerName") {
                        $ownerName = $child->textContent;
                    } else if($child->tagName === "Description") {
                        $description = $child->textContent;
                    } else if($child->tagName === "MaxParticipants") {
                        $maxParticipants = $child->textContent;
                    } else if($child->tagName === "Date") {
                        $date = $child->textContent;
                    } else if($child->tagName === "Time") {
                        $time = $child->textContent;
                    } else if($child->tagName === "LocationCity") {
                        $locationCity = $child->textContent;
                    } else if($child->tagName === "LocationStreet") {
                        $locationStreet = $child->textContent;
                    } else if($child->tagName === "LocationStreetNumber") {
                        $locationStreetNumber = $child->textContent;
                    } else if($child->tagName === "LocationLatitude") {
                        $locationLatitude = $child->textContent;
                    } else if($child->tagName === "LocationLongitude") {
                         $locationLongitude= $child->textContent;
                    }
                }

                $invitation = new Invitation($id, $name, $ownerId, $ownerName, $description, $maxParticipants, $date, $time, $locationCity, $locationStreet, $locationStreetNumber, $locationLatitude, $locationLongitude);
                
                return $invitation;
            }

            return null;
        }
        
        public static function queryComments($id) 
        {
            $data = array('action' => 'invitation_get_comments', 'id' => $id);

            $request = new PostRequest($data);
            $request->execute();
                                    
            $comments = new ArrayObject;
            
            $xml = new DOMDocument();
            $xml->loadXML($request->response);

            $commentNodes = $xml->getElementsByTagName("comment");
                
            foreach($commentNodes as $commentNode) {
                $message = "";
                $authorId = "";
                $authorName = "";
                $time = "";
                
                $children = $commentNode->getElementsByTagName("*");
                foreach($children as $child) {
                    if($child->tagName === "message") {
                        $message = $child->textContent;
                    } else if($child->tagName === "authorId") {
                        $authorId = $child->textContent;
                    } else if($child->tagName === "authorName") {
                        $authorName = $child->textContent;
                    } else if($child->tagName === "time") {
                        $time = $child->textContent;
                    } 
                }
                                
                $comment = new Comment($message, $authorId, $authorName, $time);
                
                $comments->append($comment);
            }

            return $comments;
        }


        public static function create($name, $description, $maxParticipants, $date, $time, $locationCity, $locationStreet, $locationStreetNumber, $locationLatitude, $locationLongitude)
        {
            $data = array('action' => 'invitation_create'
                , 'name' => $name
                , 'description' => $description
                , 'maxParticipants' => $maxParticipants
                , 'date' => $date
                , 'time' => $time
                , 'locationCity' => $locationCity
                , 'locationStreet' => $locationStreet
                , 'locationStreetNumber' => $locationStreetNumber
                , 'locationLatitude' => $locationLatitude
                , 'locationLongitude' => $locationLongitude);

            $request = new PostRequest($data);
            $request->execute();

            return $request->responseValue;
        }
        
        public static function postComment($invitationId, $comment)
        {
            $data = array('action' => 'invitation_post_comment', 'id' => $invitationId, 'comment' => $comment);

            $request = new PostRequest($data);
            $request->execute();

            return $request->responseValue;   
        }
    }
?>