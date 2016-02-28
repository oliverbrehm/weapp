<?php

    require_once 'XMLMessage.php';

    class Event
    {
        private static $xmlResponse;    
        
        public static function setXMLResponse($xmlResponse)
        {
            Event::$xmlResponse = $xmlResponse;
        }
        
        public static function processAction($action) 
        {
            if($action == "event_create") {
                if(empty($_POST['event_name']) || empty($_POST['event_description'])) {
                    Event::$xmlResponse->sendError("Event name or description not specified");
                } else {
                    Event::create($_POST['event_name'], $_POST['event_description']);
                }
                return true;
            } else if($action == "event_post_comment") {
                if(empty($_POST['event_id']) || empty($_POST['event_comment'])) {
                    Event::$xmlResponse->sendError("Event id or comment not specified");
                } else {
                    Event::postComment($_POST['event_id'], $_POST['event_comment']);
                }
                return true;            
            } else if($action == "event_get_comments") {
                if(empty($_POST['event_id'])) {
                    Event::$xmlResponse->sendError("Event id not specified");
                } else {
                    Event::queryComments($_POST['event_id']);
                }                
                return true;
            } else if($action == "event_get_all") {
                Event::queryAll();
                return true;
            } else if($action == "event_get_user") {
                if(empty($_POST['user_id'])) {
                    Event::$xmlResponse->sendError("User id not specified");
                } else {
                    Event::queryByUser($_POST['user_id']);
                }
                return true;
            } else if($action == "event_get_details") {
                if(empty($_POST['event_id'])) {
                    Event::$xmlResponse->sendError("Event id not specified");
                } else {
                    Event::queryDetails($_POST['event_id']);
                }
                return true;
            } 
            
            return false;
        }
        
        public static function create($name, $description)
        {
            if(empty($_SESSION['username'])) {
                return;
            }

            $checkeventname = mysql_query("SELECT * FROM events WHERE name = '".$name."'");

            if(mysql_num_rows($checkeventname) >= 1)
            {
                Event::$xmlResponse->sendError("Event with the same name exists");
            }
            else
            {
                $result = mysql_query("SELECT id FROM users WHERE name = '".$_SESSION['username']."'");
                $row = mysql_fetch_array($result);
                $user_id = $row['id'];
                $createEventQuery = mysql_query("INSERT INTO events (name, description, owner_id) VALUES('".$name."', '".$description."', '".$user_id."')");
                if($createEventQuery)
                {
                    Event::$xmlResponse->sendMessage("Event ".$name." successfully created.");
                }
                else
                {
                    Event::$xmlResponse->sendError("Failed to create event.");
                }
            }  
        }
        
        public static function postComment($eventId, $comment)
        {
            if(empty($_SESSION['username'])) {
                return;
            }

            $result = mysql_query("SELECT id FROM users WHERE name = '".$_SESSION['username']."'");
            $row = mysql_fetch_array($result);
            
            $user_id = $row['id'];

            $postCommentQuery = mysql_query("INSERT INTO event_post (user_id, event_id, message) VALUES('".$user_id."', '".$eventId."', '".$comment."')");
            if($postCommentQuery)
            {
                Event::$xmlResponse->sendMessage("Comment successfully posted.");
            }
            else
            {
                Event::$xmlResponse->sendError("Failed to post comment.");
            }
        }

        /// returns a list of event headers containg id and name
        public static function queryAll()
        {
            // TODO if logged in
            Event::$xmlResponse->addResponse(true);
            $events = Event::$xmlResponse->addList("eventList");

            $result = mysql_query("SELECT id, name FROM events");

            while($row = mysql_fetch_array($result))
            {
                if(isset($row['id']) && isset($row['name'])) {
                    $event = $events->addList("event");
                    
                    $event->addElement('id', $row['id']);
                    $event->addElement('name', $row['name']);
                }
            }

            Event::$xmlResponse->writeOutput();
        }
        
        public static function queryByUser($userId)
        {
            // TODO if logged in
            Event::$xmlResponse->addResponse(true);
            $events = Event::$xmlResponse->addList("eventList");

            $result = mysql_query("SELECT id, name FROM events WHERE owner_id='".$userId."'");

            while($row = mysql_fetch_array($result))
            {
                if(isset($row['id']) && isset($row['name'])) {
                    $event = $events->addList("event");
                    
                    $event->addElement('id', $row['id']);
                    $event->addElement('name', $row['name']);
                }
            }

            Event::$xmlResponse->writeOutput();
        }
        
        public static function queryComments($eventId)
        {
            // TODO if logged in
            Event::$xmlResponse->addResponse(true);
            $comments = Event::$xmlResponse->addList("commentList");

            $result = mysql_query("SELECT user_id, message, time FROM event_post WHERE event_id='".$eventId."'");

            while($row = mysql_fetch_array($result))
            {
                if(isset($row['user_id']) && isset($row['message']) && isset($row['time'])) {
                    $comment = $comments->addList("comment");
                    $userId = $row['user_id'];
                    $username = "";
                    // get user name
                    $result_user = mysql_query("SELECT name FROM users WHERE id='".$userId."'");
                    while($row_user = mysql_fetch_array($result_user)) {
                        // TODO check numenteries
                        $username = $row_user['name'];
                    }

                    $comment->addElement('message', $row['message']);
                    $comment->addElement('authorId', $userId);
                    $comment->addElement('authorName', $username);
                    $comment->addElement('time', $row['time']);
                }
            }

            Event::$xmlResponse->writeOutput();                   
        }

        public static function queryDetails($id) 
        {
            $result = mysql_query("SELECT * FROM events WHERE id='".$id."'");

            // TODO check #rows == 1
            $row = mysql_fetch_array($result);

            if(isset($row['owner_id']) && isset($row['name']) && isset($row['description'])) {
                $name = $row['name'];
                $description = $row['description'];
                
                // TODO combine 2 sql queries to one
                $ownerId = $row['owner_id'];
                $result = mysql_query("SELECT name FROM users WHERE id='".$ownerId."'");            
                // TODO check #rows == 1
                $user_row = mysql_fetch_array($result);
                $ownerName = $user_row['name'];
                
                Event::$xmlResponse->addResponse(true);
                
                $event = Event::$xmlResponse->addList("event");

                $event->addElement('id', $id);
                $event->addElement('name', $name);
                $event->addElement('ownerId', $ownerId);
                $event->addElement('ownerName', $ownerName);
                $event->addElement('description', $description);

                Event::$xmlResponse->writeOutput();
            } else {
                xml_error('Event owner name not found.');
            }
        }
    }    
    
?>
