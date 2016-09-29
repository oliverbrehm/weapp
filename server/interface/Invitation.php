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
            } else if($action == "invitation_query") {
                Invitation::query();
                return true;
            } else if($action == "invitation_query_participating") {
                if(empty($_POST['userId'])) {
                    Invitation::$xmlResponse->sendError("UserId not specified");
                } else {
                    Invitation::queryParticipating($_POST['userId']);
                }
                return true;
            } else if($action == "joinRequest_query") {
                Invitation::queryJoinRequests();
                return true;
            } else if($action == "invitation_get_details") {
                if(empty($_POST['id'])) {
                    Invitation::$xmlResponse->sendError("Invitation id not specified");
                } else {
                    Invitation::queryDetails($_POST['id']);
                }
                return true;
            } else if($action == "invitation_join_request") {
                if(empty($_POST['id']) || empty($_POST['userId']) || empty($_POST['numParticipants'])) {
                    Invitation::$xmlResponse->sendError("Invitation id, user id or number of participants not specified");
                } else {
                    Invitation::createJoinRequest($_POST['id'], $_POST['userId'], $_POST['numParticipants']);
                }
                return true;
            } else if($action == "joinRequest_accept") {
                if(empty($_POST['id'])) {
                    Invitation::$xmlResponse->sendError("Request id not specified");
                } else {
                    Invitation::acceptJoinRequest($_POST['id']);
                }
                return true;            
            } else if($action == "joinRequest_reject") {
                if(empty($_POST['id'])) {
                    Invitation::$xmlResponse->sendError("Request id not specified");
                } else {
                    Invitation::rejectJoinRequest($_POST['id']);
                }
                return true;            
            } else if($action == "invitation_get_participants") {
                if(empty($_POST['id'])) {
                    Invitation::$xmlResponse->sendError("Request id not specified");
                } else {
                    Invitation::getParticipants($_POST['id']);
                }
                return true;            
            }
            
            return false;
        }
        
        public static function create($name, $description, $maxParticipants, $date, $time, $locationCity, $locationStreet, $locationStreetNumber, $locationLatitude, $locationLongitude)
        {
            if(empty($_SESSION['userId'])) {
                return;
            }

            $checkinvitationname = mysql_query("SELECT * FROM Invitation WHERE Name = '".$name."'");

            if(mysql_num_rows($checkinvitationname) >= 1)
            {
                Invitation::$xmlResponse->sendError("Invitation with the same name exists");
            }
            else
            {
                $user_id = $_SESSION['userId'];
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
        
        public static function createJoinRequest($id, $userId, $numParticipants)
        {
            if(empty($_SESSION['userId'])) {
                return;
            }
            
            $checkexistingrequest = mysql_query("SELECT * FROM JoinRequest WHERE InvitationID = '".$id."' AND UserID = '".$userId."'");
            if(mysql_num_rows($checkexistingrequest) >= 1) {
                Invitation::$xmlResponse->sendError("Request was already created");
                return;
            }
            
            $checkAlreadyParticipating = mysql_query("SELECT * FROM Invitation, InvitationParticipant WHERE Invitation.InvitationID=InvitationParticipant.InvitationID AND InvitationParticipant.UserID='".$userId."' AND InvitationParticipant.InvitationID = '".$id."'");
            if(mysql_num_rows($checkAlreadyParticipating) >= 1) {
                Invitation::$xmlResponse->sendError("User already participates in invitation");
                return;
            }

            $createRequest = mysql_query("INSERT INTO JoinRequest (InvitationID, UserID, NumParticipants) VALUES('".$id."', '".$userId."', '".$numParticipants."')");
            if($createRequest)
            {
                Invitation::$xmlResponse->sendMessage("Request successfully created.");
            }
            else
            {
                Invitation::$xmlResponse->sendError("Failed to create request.");
            }
        }
        
        public static function acceptJoinRequest($requestId)
        {
            if(empty($_SESSION['userId'])) {
                return;
            }
            
            // get the request
            $joinRequest = mysql_query("SELECT UserID, InvitationID, NumParticipants FROM JoinRequest WHERE RequestID='".$requestId."'");
            if(!$joinRequest) {
                Invitation::$xmlResponse->sendError("Failed to get join request.");
                return;
            }
            
            $row = mysql_fetch_array($joinRequest);
            if(!$row) {
                Invitation::$xmlResponse->sendError("Failed to get join request data.");
                return;
            }
            
            $userId = $row['UserID'];
            $invitationId = $row['InvitationID'];
            $numParticipants = $row['NumParticipants'];
            
            $sql = "INSERT INTO InvitationParticipant (UserID, InvitationID, NumberOfPersons) VALUES ('".$userId."','".$invitationId."','".$numParticipants."')";
            $participantRequest = mysql_query($sql);

            if(!$participantRequest) {
                Invitation::$xmlResponse->sendError("Failed to create participation entry.");
                return;
            }
            
            $deleteRequest = mysql_query("DELETE FROM JoinRequest WHERE RequestID = '".$requestId."'");

            if(!$deleteRequest) {
                Invitation::$xmlResponse->sendError("Failed to remove the request after joining.");
                return;
            }
            
            Invitation::$xmlResponse->sendMessage("Participation successfully created.");
        }
        
        public static function rejectJoinRequest($requestId)
        {
            if(empty($_SESSION['userId'])) {
                return;
            }
            
            // get the request
            $deleteRequest = mysql_query("DELETE FROM JoinRequest WHERE RequestID = '".$requestId."'");
            if(!$deleteRequest) {
                Invitation::$xmlResponse->sendError("Failed to delete request.");
            } else {
                Invitation::$xmlResponse->sendMessage("Successfully deleted request.");
            }
        }
        
        public static function getParticipants($invitationId)
        {
            // TODO if logged in
            Invitation::$xmlResponse->addResponse(true);
            $invitations = Invitation::$xmlResponse->addList("ParticipantList");

            $sql = "SELECT User.UserID, User.FirstName, User.LastName, InvitationParticipant.NumberOfPersons FROM InvitationParticipant, Invitation, User WHERE Invitation.InvitationID = '".$invitationId."' AND InvitationParticipant.InvitationID=Invitation.InvitationID AND User.UserID=InvitationParticipant.UserID";        
            $result = mysql_query($sql);

            while($row = mysql_fetch_array($result))
            {
                if(isset($row['UserID']) && isset($row['FirstName']) && isset($row['LastName']) && isset($row['NumberOfPersons'])) {
                    $invitation = $invitations->addList("Participant");
                    $invitation->addElement('userId', $row['UserID']);
                    $invitation->addElement('firstName', $row['FirstName']);
                    $invitation->addElement('lastName', $row['LastName']);
                    $invitation->addElement('numParticipants', $row['NumberOfPersons']);
                }
            }

            Invitation::$xmlResponse->writeOutput();
        }
        
        public static function postComment($invitationId, $comment)
        {
            if(empty($_SESSION['userId'])) {
                return;
            }

            $user_id = $_SESSION['userId'];

            // TODO insert timestamp (current time)
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
        public static function query()
        {
            // TODO if logged in
            Invitation::$xmlResponse->addResponse(true);
            $invitations = Invitation::$xmlResponse->addList("invitationList");

            $sql = "SELECT InvitationID, Name FROM Invitation WHERE 1";
            
            if(!empty($_POST['userID'])) {
                $sql .= " AND UserID='".$_POST['userID']."'";
            }       
            
            $result = mysql_query($sql);

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
        
        /// returns a list of invitation headers containg id and name
        public static function queryParticipating($userID)
        {
            // TODO if logged in
            Invitation::$xmlResponse->addResponse(true);
            $invitations = Invitation::$xmlResponse->addList("invitationList");

            $sql = "SELECT Invitation.InvitationID, Invitation.Name FROM Invitation, InvitationParticipant WHERE InvitationParticipant.InvitationID = Invitation.InvitationID AND InvitationParticipant.UserID='".$userID."'";
            
            $result = mysql_query($sql);

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
        
        public static function queryJoinRequests()
        {
            // TODO if logged in
            Invitation::$xmlResponse->addResponse(true);
            $invitations = Invitation::$xmlResponse->addList("joinRequestList");

            $sql = "SELECT JR.RequestID, JR.UserID, JR.InvitationID, JR.NumParticipants, I.UserID as ReceiverID, I.InvitationID, I.MaxParticipants, I.Name as InvitationName FROM JoinRequest as JR, Invitation as I WHERE JR.InvitationID=I.InvitationID";
            
            if(!empty($_POST['userID'])) {
                $sql .= " AND (I.UserID='".$_POST['userID']."' OR JR.UserID='".$_POST['userID']."')";
            }
                        
            $result = mysql_query($sql);

            while($row = mysql_fetch_array($result))
            {
                if(isset($row['RequestID']) && isset($row['UserID']) && isset($row['InvitationID']) && isset($row['NumParticipants']) && isset($row['MaxParticipants']) && isset($row['InvitationName'])) {
                    $invitation = $invitations->addList("JoinRequest");
                    $invitation->addElement('id', $row['RequestID']);
                    $invitation->addElement('userId', $row['UserID']);
                    $invitation->addElement('invitationId', $row['InvitationID']);
                    $invitation->addElement('maxParticipants', $row['MaxParticipants']);
                    $invitation->addElement('numParticipants', $row['NumParticipants']);
                    $invitation->addElement('invitationName', $row['InvitationName']);             
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
                    $username = ""; // TODO
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
                $result = mysql_query("SELECT FirstName, LastName FROM User WHERE UserID='".$ownerId."'");            
                // TODO check #rows == 1
                $user_row = mysql_fetch_array($result);
                $ownerFirstName = $user_row['FirstName'];
                $ownerLastName = $user_row['LastName'];
                
                Invitation::$xmlResponse->addResponse(true);
                
                $invitation = Invitation::$xmlResponse->addList("invitation");

                $invitation->addElement('InvitationId', $id);
                $invitation->addElement('Name', $name);
                $invitation->addElement('OwnerId', $ownerId);
                $invitation->addElement('OwnerFirstName', $ownerFirstName);
                $invitation->addElement('OwnerLastName', $ownerLastName);
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
