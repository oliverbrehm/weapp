<?php

    require_once('XMLMessage.php');
    require_once('User.php');
    require_once('Invitation.php');
    
    class APIResponse
    {
        protected $action;
        protected $xmlResponse;
        
        public function __construct() {
            error_reporting(E_ALL ^ E_WARNING);
            ini_set('display_errors', 'Off');   
            
            if(session_id() == '' || !isset($_SESSION)) {
                session_start();
            }
            
            $this->readAction();

            $this->initializeDatabase();
            
            $this->xmlResponse = new XMLMessage();
            
            User::setXMLResponse($this->xmlResponse);
            Invitation::setXMLResponse($this->xmlResponse);
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
                if(!Invitation::processAction($this->action)) {
                    $this->xmlResponse->sendError("Invalid action specified.");
                }
            } 
        }
    }

    $response = new APIResponse;  
    $response->processAction();
?>