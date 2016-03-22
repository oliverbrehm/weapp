<?php

    class Invitation
    {
        public $id;
        public $name;
        public $ownerId;
        public $ownerName;
        public $description;
               
        public function __construct($id, $name, $ownerId, $ownerName, $description) {
            $this->id = $id;
            $this->name = $name;
            $this->ownerId = $ownerId;
            $this->ownerName = $ownerName;
            $this->description = $description;
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

                $invitation = new Invitation($invitationId, $invitationName, "", "", "");
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

                $invitation = new Invitation($invitationId, $invitationName, "", "", "");
                $invitations->append($invitation);
            }

            return $invitations;
        }
        
        public static function queryDetails($id) 
        {
            $data = array('action' => 'invitation_get_details', 'invitation_id' => $id);

            $request = new PostRequest($data);
            $request->execute();
                                    
            $xml = new DOMDocument();
            $xml->loadXML($request->response);

            $invitationNodes = $xml->getElementsByTagName("invitation");
                
            foreach($invitationNodes as $invitationNode) {
                
                $children = $invitationNode->getElementsByTagName("*");
                foreach($children as $child) {
                    if($child->tagName === "id") {
                        $invitationId = $child->textContent;
                    } else if($child->tagName === "name") {
                        $invitationName = $child->textContent;
                    } else if($child->tagName === "ownerId") {
                        $ownerId = $child->textContent;
                    } else if($child->tagName === "ownerName") {
                        $ownerName = $child->textContent;
                    } else if($child->tagName === "description") {
                        $invitationDescription = $child->textContent;
                    }
                }

                $invitation = new Invitation($invitationId, $invitationName, $ownerId, $ownerName, $invitationDescription);
                
                return $invitation;
            }

            return null;
        }
        
        public static function queryComments($id) 
        {
            $data = array('action' => 'invitation_get_comments', 'invitation_id' => $id);

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


        public static function create($name, $description)
        {
            $data = array('action' => 'invitation_create', 'invitation_name' => $name, 'invitation_description' => $description);

            $request = new PostRequest($data);
            $request->execute();

            return $request->responseValue;
        }
        
        public static function postComment($invitationId, $comment)
        {
            $data = array('action' => 'invitation_post_comment', 'invitation_id' => $invitationId, 'invitation_comment' => $comment);

            $request = new PostRequest($data);
            $request->execute();

            return $request->responseValue;   
        }
    }
?>