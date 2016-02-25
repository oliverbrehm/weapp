<?php

    class XMLMessage
    {
        protected $xmlDocument;
        protected $database;
        
        public function __construct() {
            $this->xmlDocument = new DOMDocument("1.0", "UTF-8");
        }
        
        public function addResponse($success, $message)
        {        
            $node_response = $this->xmlDocument->createElement("response");
            $attr_response_value = $this->xmlDocument->createAttribute("success");
            $attr_response_value->value = json_encode($success);
            $node_response->appendChild($attr_response_value);

            $attr_response_text = $this->xmlDocument->createAttribute("message");
            $attr_response_text->value = $message;
            $node_response->appendChild($attr_response_text);

            $this->xmlDocument->appendChild($node_response);
        }
        
        public function sendError($message)
        {
            $this->addResponse(false, "Error: ".$message);
            $this->writeOutput();
        }
        
        public function sendMessage($message)
        {
            $this->addResponse(true, $message);
            $this->writeOutput();
        }
        
        private function writeOutput()
        {
            echo $this->xmlDocument->saveXML();
        }    
    }
    
?>