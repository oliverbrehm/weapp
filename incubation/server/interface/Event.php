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
            } else if($action == "event_get_all") {
                Event::queryAllIDs();
                return true;
            } else if($action == "event_get_description") {
                if(empty($_POST['event_id'])) {
                    Event::$xmlResponse->sendError("Event id not specified");
                } else {
                    Event::queryDescription($_POST['event_id']);
                }
                return true;
            } else if($action == "event_get_user") {
                if(empty($_POST['event_id'])) {
                    Event::$xmlResponse->sendError("Event id not specified");
                } else {
                    Event::queryUserName($_POST['event_id']);
                }
                return true;
            } else if($action == "event_get_name") {
                if(empty($_POST['event_id'])) {
                    Event::$xmlResponse->sendError("Event id not specified");
                } else {
                    Event::queryName($_POST['event_id']);
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

        // returns a list of event ids ; seperated
        public static function queryAllIDs()
        {
            // TODO if logged in

            $ids = new ArrayObject;

            $result = mysql_query("SELECT id FROM events");

            while($row = mysql_fetch_array($result))
            {
                if(isset($row['id'])) {
                    $ids->append($row['id']);
                }
            }

            Event::$xmlResponse->sendIdList("eventIds", "eventId", $ids);
        }

        public static function queryUserName($id) 
        {
            $result = mysql_query("SELECT owner_id FROM events WHERE id='".$id."'");

            // TODO check #rows == 1
            $row = mysql_fetch_array($result);

            if(isset($row['owner_id'])) {
                $owner_id = $row['owner_id'];

                // TODO combine 2 sql queries to one
                $result = mysql_query("SELECT name FROM users WHERE id='".$owner_id."'");

                // TODO check #rows == 1
                $row = mysql_fetch_array($result);

                if(isset($row['name'])) {
                    Event::$xmlResponse->sendString("ownerName", $row['name']);
                    
                }
            } else {
                xml_error('Event owner name not found.');
            }
        }

        public static function queryDescription($id)
        {
            $result = mysql_query("SELECT description FROM events WHERE id='".$id."'");

            // TODO check #rows == 1
            $row = mysql_fetch_array($result);

            if(isset($row['description'])) {
                Event::$xmlResponse->sendString("description", $row['description']);
                
            } else {
                xml_error('Event description not found.');
            }
        }

        public static function queryName($id) {        
            $result = mysql_query("SELECT name FROM events WHERE id='".$id."'");

            // TODO check #rows == 1
            $row = mysql_fetch_array($result);

            if(isset($row['name'])) {
                Event::$xmlResponse->sendString("name", $row['name']);
                
            } else {
                xml_error('Event name not found.');
            }
        }
    }    
    
?>
