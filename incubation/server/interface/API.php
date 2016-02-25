<?php

    require_once('XMLMessage.php');
    require_once('User.php');
    require_once('Event.php');

    class APIResponse
    {
        protected $action;
        protected $xmlResponse;
        
        public function __construct() {
            error_reporting(-1);
            ini_set('display_errors', 'On');   
            
            if(session_id() == '' || !isset($_SESSION)) {
                session_start();
            }
            
            $this->initializeDatabase();
            $this->readAction();
            
            $this->xmlResponse = new XMLMessage();
        }
        
        private function readAction() // -> $success: Bool
        {
            if(empty($_POST['action'])) {
                return false;
            }
            
            $this->action = $_POST['action'];
        }
        
        private function initializeDatabase()
        {
            $dbhost = "rdbms.strato.de";
            $dbname = "DB2437647";
            $dbuser = "U2437647";
            $dbpass = "int-testDB0";

            mysql_connect($dbhost, $dbuser, $dbpass) or die("MySQL Error: " . mysql_error());
            $this->database = mysql_select_db($dbname) or die("MySQL Error: " . mysql_error());
        }
        
        public function processAction()
        {
            if($this->action == "user_register") {
                if(empty($_POST["username"]) || empty($_POST["password"])) {
                    $this->xmlResponse->sendError("Username or password not specified");
                } else {
                    $username = $_POST['username'];//);
                    $password = $_POST['password'];//); TODO encrypt

                    $user = new User($this->xmlResponse);
                    $user->register($username, $password);
                }
            } else if($this->action == "user_login") {
                if(empty($_POST["username"]) || empty($_POST["password"])) {
                    $this->xmlResponse->sendError("Username or password not specified");
                } else {
                    //$username = mysql_real_escape_string($_POST['username']);
                    //$password = md5(mysql_real_escape_string($_POST['password']); //TODO encrypt

                    $username = $_POST['username'];
                    $password = $_POST['password'];

                    $user = new User($this->xmlResponse);
                    $user->login($username, $password);
                }
            } else if($this->action == "user_logout") {
                $user = new User($this->xmlResponse);
                $user->logout();
            } else if($this->action == "user_logged_in") {
                $user = new User($this->xmlResponse);
                $user->loggedIn();
            } else if($this->action == "get_users") {
                $user = new User($this->xmlResponse);
                $user->retrieveAllIDs();
            } else if($this->action == "event_create") {
                if(empty($_POST['event_name']) || empty($_POST['event_description'])) {
                    $this->xmlResponse->sendError("Event name or description not specified");
                } else {
                    $event = new Event($this->xmlResponse);
                    $event->create($_POST['event_name'], $_POST['event_description']);
                }
            } else if($this->action == "event_get_all") {
                $event = new Event($this->xmlResponse);
                $event->retrieveAllIDs();
            } else if($this->action == "event_get_description") {
                if(empty($_POST['event_id'])) {
                    $this->xmlResponse->sendError("Event id not specified");
                } else {
                    $event = new Event($this->xmlResponse);
                    $event->retrieveDescription($_POST['event_id']);
                }
            } else if($this->action == "event_get_user") {
                if(empty($_POST['event_id'])) {
                    $this->xmlResponse->sendError("Event id not specified");
                } else {
                    $event = new Event($this->xmlResponse);
                    $event->retrieveUser($_POST['event_id']);
                }
            } else if($this->action == "event_get_name") {
                if(empty($_POST['event_id'])) {
                    $this->xmlResponse->sendError("Event id not specified");
                } else {
                    $event = new Event($this->xmlResponse);
                    $event->retrieveName($_POST['event_id']);
                }
            } else {
                $this->xmlResponse->sendError("Invalid action specified.");
            }
        }
    }

    $response = new APIResponse;
    
    $response->processAction();
?>