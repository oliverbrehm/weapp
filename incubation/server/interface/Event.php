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

            $checkeventname = mysql_query("SELECT * FROM Event WHERE Name = '".$name."'");

            if(mysql_num_rows($checkeventname) >= 1)
            {
                Event::$xmlResponse->sendError("Event with the same name exists");
            }
            else
            {
                $result = mysql_query("SELECT UserID FROM User WHERE Name = '".$_SESSION['username']."'");
                $row = mysql_fetch_array($result);
                $user_id = $row['UserID'];
                $createEventQuery = mysql_query("INSERT INTO Event (Name, Description, UserID) VALUES('".$name."', '".$description."', '".$user_id."')");
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

            $result = mysql_query("SELECT UserID FROM User WHERE Name = '".$_SESSION['username']."'");
            $row = mysql_fetch_array($result);
            
            $user_id = $row['UserID'];

            $postCommentQuery = mysql_query("INSERT INTO EventPost (UserID, EventID, Message) VALUES('".$user_id."', '".$eventId."', '".$comment."')");
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

            $result = mysql_query("SELECT EventID, Name FROM Event");

            while($row = mysql_fetch_array($result))
            {
                if(isset($row['EventID']) && isset($row['Name'])) {
                    $event = $events->addList("event");
                    $event->addElement('id', $row['EventID']);
                    $event->addElement('name', $row['Name']);
                }
            }

            Event::$xmlResponse->writeOutput();
        }
        
        public static function queryByUser($userId)
        {
            // TODO if logged in
            Event::$xmlResponse->addResponse(true);
            $events = Event::$xmlResponse->addList("eventList");

            $result = mysql_query("SELECT EventID, Name FROM Event WHERE UserID='".$userId."'");

            while($row = mysql_fetch_array($result))
            {
                if(isset($row['EventID']) && isset($row['Name'])) {
                    $event = $events->addList("event");
                    
                    $event->addElement('id', $row['EventID']);
                    $event->addElement('name', $row['Name']);
                }
            }

            Event::$xmlResponse->writeOutput();
        }
        
        public static function queryComments($eventId)
        {
            // TODO if logged in
            Event::$xmlResponse->addResponse(true);
            $comments = Event::$xmlResponse->addList("commentList");

            $result = mysql_query("SELECT UserID, Message, Time FROM EventPost WHERE EventID='".$eventId."'");

            while($row = mysql_fetch_array($result))
            {
                if(isset($row['UserID']) && isset($row['Message']) && isset($row['Time'])) {
                    $comment = $comments->addList("comment");
                    $userId = $row['UserID'];
                    $username = "";
                    // get user name
                    $result_user = mysql_query("SELECT Name FROM User WHERE UserID='".$userId."'");
                    while($row_user = mysql_fetch_array($result_user)) {
                        // TODO check numenteries
                        $username = $row_user['Name'];
                    }

                    $comment->addElement('message', $row['Message']);
                    $comment->addElement('authorId', $userId);
                    $comment->addElement('authorName', $username);
                    $comment->addElement('time', $row['Time']);
                }
            }

            Event::$xmlResponse->writeOutput();                   
        }

        public static function queryDetails($id) 
        {
            $result = mysql_query("SELECT * FROM Event WHERE EventID='".$id."'");

            // TODO check #rows == 1
            $row = mysql_fetch_array($result);

            if(isset($row['UserID']) && isset($row['Name']) && isset($row['Description'])) {
                $name = $row['Name'];
                $description = $row['Description'];
                
                // TODO combine 2 sql queries to one
                $ownerId = $row['UserID'];
                $result = mysql_query("SELECT Name FROM User WHERE UserID='".$ownerId."'");            
                // TODO check #rows == 1
                $user_row = mysql_fetch_array($result);
                $ownerName = $user_row['Name'];
                
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
