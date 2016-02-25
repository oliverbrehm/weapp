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
            
            User::setXMLResponse($this->xmlResponse);
            Event::setXMLResponse($this->xmlResponse);
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
            if(!User::processAction($this->action)) {
                if(!Event::processAction($this->action)) {
                    $this->xmlResponse->sendError("Invalid action specified.");
                }
            }
        }
    }

    $response = new APIResponse;  
    $response->processAction();
?>