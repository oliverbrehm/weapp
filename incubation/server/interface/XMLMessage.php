<?php

    class XMLMessage
    {
        protected $xmlDocument;
        protected $database;
        
        protected $responseNode;


        public function __construct() {
            $this->xmlDocument = new DOMDocument("1.0", "UTF-8");
        }
        
        public function addResponse($success)
        {        
            $this->responseNode = new XMLList("response");  

            $this->xmlDocument->appendChild($this->responseNode);

            $this->responseNode->init();
                      
            $attr_response_value = $this->xmlDocument->createAttribute("success");
            $attr_response_value->value = json_encode($success);
            $this->responseNode->appendChild($attr_response_value);

            return $this->responseNode;
        }            
        
        public function sendError($message)
        {
            $this->addResponse(false);
            $this->responseNode->addString("error", $message);
            $this->writeOutput();
        }
        
        public function sendMessage($message)
        {
            $this->sendString("message", $message);
        }
        
        public function sendString($name, $string)
        {
            $this->addResponse(true);
            $this->responseNode->addString($name, $string);
            $this->writeOutput();
        }
        
        public function sendId($name, $id)
        {
            $this->addResponse(true);
            $this->responseNode->addId($name, $id);
            $this->writeOutput();
        }
        
        public function sendIdList($listName, $itemName, $idList)
        {
            $this->addResponse(true);
            $list = $this->responseNode->addList($listName);
            foreach($idList as $id)
            {
                $list->addId($itemName, $id);
            }
            $this->writeOutput();
        }
        
        private function writeOutput()
        {
            echo $this->xmlDocument->saveXML();
        }    
    }
    
    class XMLList extends DOMElement
    {
        private $name;
        
        public function __construct($name) {   
            if($name === "response") {
                parent::__construct("response", null, null);     
            } else {
                parent::__construct("list", null, null);     
            }
            $this->name = $name;
        }
        
        public function init()
        {
            $attr_type = $this->ownerDocument->createAttribute("name");
            $attr_type->value = $this->name;
            $this->appendChild($attr_type);
        }
        
        public function addElement($type, $name, $data)
        {            
            $element = $this->ownerDocument->createElement($type, $data);

            $attr_type = $this->ownerDocument->createAttribute("name");
            $attr_type->value = $name;
            $element->appendChild($attr_type);

            $this->appendChild($element);
        }
        
        public function addString($name, $string)
        {
            $this->addElement("string", $name, $string);
        }
        
        public function addId($name, $id)
        {            
            $this->addElement("id", $name, $id);
        }
        
        public function addList($name)
        {
            $list = new XMLList($name); 
            $this->appendChild($list);            
            $list->init();
            
            return $list;
        }
    }
    
?>