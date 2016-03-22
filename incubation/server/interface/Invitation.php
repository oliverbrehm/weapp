<?php

    require_once 'XMLMessage.php';

    class Invitation
    {
        private static $xmlResponse;    
        
        public static function setXMLResponse($xmlResponse)
        {
            Invitation::$xmlResponse = $xmlResponse;
        }
        
        public static function processAction($action) 
        {
            if($action == "invitation_create") {
                if(empty($_POST['name']) || empty($_POST['description'])) {
                    Invitation::$xmlResponse->sendError("Invitation name or description not specified");
                } else {
                    $name = $_POST['name'];
                    $description = $_POST['description'];
                    $maxParticipants = $_POST['maxParticipants'];
                    $date = $_POST['date'];
                    $time = $_POST['time'];
                    $locationCity = $_POST['locationCity'];
                    $locationStreet = $_POST['locationStreet'];
                    $locationStreetNumber = $_POST['locationStreetNumber'];
                    $locationLatitude = $_POST['locationLatitude'];
                    $locationLongitude = $_POST['locationLongitude'];
            
                    Invitation::create($name, $description, $maxParticipants, $date, $time, $locationCity, $locationStreet, $locationStreetNumber, $locationLatitude, $locationLongitude);
                }
                return true;
            } else if($action == "invitation_post_comment") {
                if(empty($_POST['id']) || empty($_POST['comment'])) {
                    Invitation::$xmlResponse->sendError("Invitation id or comment not specified");
                } else {
                    Invitation::postComment($_POST['id'], $_POST['comment']);
                }
                return true;            
            } else if($action == "invitation_get_comments") {
                if(empty($_POST['id'])) {
                    Invitation::$xmlResponse->sendError("Invitation id not specified");
                } else {
                    Invitation::queryComments($_POST['id']);
                }                
                return true;
            } else if($action == "invitation_get_all") {
                Invitation::queryAll();
                return true;
            } else if($action == "invitation_get_user") {
                if(empty($_POST['user_id'])) {
                    Invitation::$xmlResponse->sendError("User id not specified");
                } else {
                    Invitation::queryByUser($_POST['user_id']);
                }
                return true;
            } else if($action == "invitation_get_details") {
                if(empty($_POST['id'])) {
                    Invitation::$xmlResponse->sendError("Invitation id not specified");
                } else {
                    Invitation::queryDetails($_POST['id']);
                }
                return true;
            } 
            
            return false;
        }
        
        public static function create($name, $description, $maxParticipants, $date, $time, $locationCity, $locationStreet, $locationStreetNumber, $locationLatitude, $locationLongitude)
        {
            if(empty($_SESSION['username'])) {
                return;
            }

            $checkinvitationname = mysql_query("SELECT * FROM Invitation WHERE Name = '".$name."'");

            if(mysql_num_rows($checkinvitationname) >= 1)
            {
                Invitation::$xmlResponse->sendError("Invitation with the same name exists");
            }
            else
            {
                $result = mysql_query("SELECT UserID FROM User WHERE Name = '".$_SESSION['username']."'");
                $row = mysql_fetch_array($result);
                $user_id = $row['UserID'];
                $createInvitationQuery = mysql_query("INSERT INTO Invitation (Name, Description, UserID, MaxParticipants, Date, Time, LocationCity, LocationStreet, LocationStreetNumber, LocationLatitude, LocationLongitude) VALUES('".$name."', '".$description."', '".$user_id."', '".$maxParticipants."', '".$date."', '".$time."', '".$locationCity."', '".$locationStreet."', '".$locationStreetNumber."', '".$locationLatitude."', '".$locationLongitude."')");
                if($createInvitationQuery)
                {
                    Invitation::$xmlResponse->sendMessage("Invitation ".$name." successfully created.");
                }
                else
                {
                    Invitation::$xmlResponse->sendError("Failed to create invitation.");
                }
            }  
        }
        
        public static function postComment($invitationId, $comment)
        {
            if(empty($_SESSION['username'])) {
                return;
            }

            $result = mysql_query("SELECT UserID FROM User WHERE Name = '".$_SESSION['username']."'");
            $row = mysql_fetch_array($result);
            
            $user_id = $row['UserID'];

            $postCommentQuery = mysql_query("INSERT INTO InvitationPost (UserID, InvitationID, Message) VALUES('".$user_id."', '".$invitationId."', '".$comment."')");
            if($postCommentQuery)
            {
                Invitation::$xmlResponse->sendMessage("Comment successfully posted.");
            }
            else
            {
                Invitation::$xmlResponse->sendError("Failed to post comment.");
            }
        }

        /// returns a list of invitation headers containg id and name
        public static function queryAll()
        {
            // TODO if logged in
            Invitation::$xmlResponse->addResponse(true);
            $invitations = Invitation::$xmlResponse->addList("invitationList");

            $result = mysql_query("SELECT InvitationID, Name FROM Invitation");

            while($row = mysql_fetch_array($result))
            {
                if(isset($row['InvitationID']) && isset($row['Name'])) {
                    $invitation = $invitations->addList("invitation");
                    $invitation->addElement('id', $row['InvitationID']);
                    $invitation->addElement('name', $row['Name']);
                }
            }

            Invitation::$xmlResponse->writeOutput();
        }
        
        public static function queryByUser($userId)
        {
            // TODO if logged in
            Invitation::$xmlResponse->addResponse(true);
            $invitations = Invitation::$xmlResponse->addList("invitationList");

            $result = mysql_query("SELECT InvitationID, Name FROM Invitation WHERE UserID='".$userId."'");

            while($row = mysql_fetch_array($result))
            {
                if(isset($row['InvitationID']) && isset($row['Name'])) {
                    $invitation = $invitations->addList("invitation");
                    
                    $invitation->addElement('id', $row['InvitationID']);
                    $invitation->addElement('name', $row['Name']);
                }
            }

            Invitation::$xmlResponse->writeOutput();
        }
        
        public static function queryComments($invitationId)
        {
            // TODO if logged in
            Invitation::$xmlResponse->addResponse(true);
            $comments = Invitation::$xmlResponse->addList("commentList");

            $result = mysql_query("SELECT UserID, Message, Time FROM InvitationPost WHERE InvitationID='".$invitationId."'");

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

            Invitation::$xmlResponse->writeOutput();                   
        }

        public static function queryDetails($id) 
        {
            $result = mysql_query("SELECT * FROM Invitation WHERE InvitationID='".$id."'");

            // TODO check #rows == 1
            $row = mysql_fetch_array($result);

            if(isset($row['UserID']) && isset($row['Name']) && isset($row['Description'])) {
                $name = $row['Name'];
                $description = $row['Description'];
                
                $maxParticipants = $row['MaxParticipants'];
                $date = $row['Date'];
                $time = $row['Time'];
                $locationCity = $row['LocationCity'];
                $locationStreet = $row['LocationStreet'];
                $locationStreetNumber = $row['LocationStreetNumber'];
                $locationLatitude = $row['LocationLatitude'];
                $locationLongitude = $row['LocationLongitude'];
                
                // TODO combine 2 sql queries to one
                $ownerId = $row['UserID'];
                $result = mysql_query("SELECT Name FROM User WHERE UserID='".$ownerId."'");            
                // TODO check #rows == 1
                $user_row = mysql_fetch_array($result);
                $ownerName = $user_row['Name'];
                
                Invitation::$xmlResponse->addResponse(true);
                
                $invitation = Invitation::$xmlResponse->addList("invitation");

                $invitation->addElement('InvitationId', $id);
                $invitation->addElement('Name', $name);
                $invitation->addElement('OwnerId', $ownerId);
                $invitation->addElement('OwnerName', $ownerName);
                $invitation->addElement('Description', $description);
                $invitation->addElement('MaxParticipants', $maxParticipants);
                $invitation->addElement('Date', $date);
                $invitation->addElement('Time', $time);
                $invitation->addElement('LocationCity', $locationCity);
                $invitation->addElement('LocationStreet', $locationStreet);
                $invitation->addElement('LocationStreetNumber', $locationStreetNumber);
                $invitation->addElement('LocationLatitude', $locationLatitude);
                $invitation->addElement('LocationLongitude', $locationLongitude);

                Invitation::$xmlResponse->writeOutput();
            } else {
                xml_error('Invitation owner name not found.');
            }
        }
    }    
    
?>
