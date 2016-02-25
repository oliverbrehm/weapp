<?php

    require_once 'XMLMessage.php';

    class Event
    {
        private $xmlResponse;
        
        public function __construct($xmlResponse) {
            $this->xmlResponse = $xmlResponse;
        }
        
        function create($name, $description)
        {
            if(empty($_SESSION['username'])) {
                return;
            }

            $checkeventname = mysql_query("SELECT * FROM events WHERE name = '".$name."'");

            if(mysql_num_rows($checkeventname) >= 1)
            {
                $this->xmlResponse->sendError("Event with the same name exists");
            }
            else
            {
                $result = mysql_query("SELECT id FROM users WHERE name = '".$_SESSION['username']."'");
                $row = mysql_fetch_array($result);
                $user_id = $row['id'];
                $createEventQuery = mysql_query("INSERT INTO events (name, description, owner_id) VALUES('".$name."', '".$description."', '".$user_id."')");
                if($createEventQuery)
                {
                    $this->xmlResponse->sendMessage("Event ".$name." successfully created.");
                }
                else
                {
                    $this->xmlResponse->sendError("Failed to create event.");
                }
            }

            
        }

        // returns a list of event ids ; seperated
        function retrieveAllIDs()
        {
            // TODO if logged in

            $ids = "";

            $result = mysql_query("SELECT * FROM events");

            while($row = mysql_fetch_array($result))
            {
                if(isset($row['name'])) {
                    if(!empty($ids)) {
                        $ids = $ids.';';
                    }
                    $ids = $ids.$row['id'];
                }
            }

            $this->xmlResponse->sendMessage($ids);
            
        }

        function retrieveUser($id) 
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
                    $this->xmlResponse->sendMessage($row['name']);
                    
                }
            } else {
                xml_error('Event owner name not found.');
            }
        }

        function retrieveDescription($id)
        {
            $result = mysql_query("SELECT description FROM events WHERE id='".$id."'");

            // TODO check #rows == 1
            $row = mysql_fetch_array($result);

            if(isset($row['description'])) {
                $this->xmlResponse->sendMessage($row['description']);
                
            } else {
                xml_error('Event description not found.');
            }
        }

        function retrieveName($id) {        
            $result = mysql_query("SELECT name FROM events WHERE id='".$id."'");

            // TODO check #rows == 1
            $row = mysql_fetch_array($result);

            if(isset($row['name'])) {
                $this->xmlResponse->sendMessage($row['name']);
                
            } else {
                xml_error('Event name not found.');
            }
        }
    }    
    
?>
