<?php

    class Event
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
    
    class EventQuery
    {
        public static function queryAll() // returns a list of events containing id and name
        {
            $data = array('action' => 'event_get_all');

            $request = new PostRequest($data);
            $request->execute();
            
            $events = new ArrayObject;
            
            $xml = new DOMDocument();
            $xml->loadXML($request->response);

            // api sends id and name
            $eventNodes = $xml->getElementsByTagName("event");

            foreach($eventNodes as $eventNode) {
                $eventId = "";//$eventNode->getElementsByTagName("id")->textContent;                    
                $eventName = "";//$eventNode->getElementsByTagName("name")->textContent;                    

                $children = $eventNode->getElementsByTagName("*");
                foreach($children as $child) {
                    if($child->tagName === "id") {
                        $eventId = $child->textContent;
                    } else if($child->tagName === "name") {
                        $eventName = $child->textContent;
                    }
                }

                $event = new Event($eventId, $eventName, "", "", "");
                $events->append($event);
            }

            return $events;
        }

        public static function queryByUser($user_id) // returns a list of events containing id and name
        {
            $data = array('action' => 'event_get_user', 'user_id' => $user_id);

            $request = new PostRequest($data);
            $request->execute();
            
            $events = new ArrayObject;
            
            $xml = new DOMDocument();
            $xml->loadXML($request->response);

            // api sends id and name
            $eventNodes = $xml->getElementsByTagName("event");

            foreach($eventNodes as $eventNode) {
                $eventId = "";//$eventNode->getElementsByTagName("id")->textContent;                    
                $eventName = "";//$eventNode->getElementsByTagName("name")->textContent;                    

                $children = $eventNode->getElementsByTagName("*");
                foreach($children as $child) {
                    if($child->tagName === "id") {
                        $eventId = $child->textContent;
                    } else if($child->tagName === "name") {
                        $eventName = $child->textContent;
                    }
                }

                $event = new Event($eventId, $eventName, "", "", "");
                $events->append($event);
            }

            return $events;
        }
        
        public static function queryDetails($id) 
        {
            $data = array('action' => 'event_get_details', 'event_id' => $id);

            $request = new PostRequest($data);
            $request->execute();
                                    
            $xml = new DOMDocument();
            $xml->loadXML($request->response);

            $eventNodes = $xml->getElementsByTagName("event");
                
            foreach($eventNodes as $eventNode) {
                
                $children = $eventNode->getElementsByTagName("*");
                foreach($children as $child) {
                    if($child->tagName === "id") {
                        $eventId = $child->textContent;
                    } else if($child->tagName === "name") {
                        $eventName = $child->textContent;
                    } else if($child->tagName === "ownerId") {
                        $ownerId = $child->textContent;
                    } else if($child->tagName === "ownerName") {
                        $ownerName = $child->textContent;
                    } else if($child->tagName === "description") {
                        $eventDescription = $child->textContent;
                    }
                }

                $event = new Event($eventId, $eventName, $ownerId, $ownerName, $eventDescription);
                
                return $event;
            }

            return null;
        }
        
        public static function queryComments($id) 
        {
            $data = array('action' => 'event_get_comments', 'event_id' => $id);

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
            $data = array('action' => 'event_create', 'event_name' => $name, 'event_description' => $description);

            $request = new PostRequest($data);
            $request->execute();

            return $request->responseValue;
        }
        
        public static function postComment($eventId, $comment)
        {
            $data = array('action' => 'event_post_comment', 'event_id' => $eventId, 'event_comment' => $comment);

            $request = new PostRequest($data);
            $request->execute();

            return $request->responseValue;   
        }
    }
?>