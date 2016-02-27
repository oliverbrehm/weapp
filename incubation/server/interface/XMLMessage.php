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
                      
            $attr_response_value = $this->xmlDocument->createAttribute("success");
            $attr_response_value->value = json_encode($success);
            $this->responseNode->appendChild($attr_response_value);

            return $this->responseNode;
        }     
        
        public function addElement($type, $id, $data)
        {
            $this->responseNode->addItem($type, $id, $data);
        }   
        
        public function addList($name)
        {
            return $this->responseNode->addList($name);
        }
                
        public function sendError($message)
        {
            $this->addResponse(false);
            $this->responseNode->addElement("error", $message);
            $this->writeOutput();
        }
        
        public function sendMessage($message)
        {
            $this->addResponse(true);
            $this->responseNode->addElement("message", $message);
            $this->writeOutput();     
        }
        
        public function sendList($listName, $itemName, $list)
        {
            $this->addResponse(true);
            $listNode = $this->responseNode->addList($listName);
            foreach($list as $item)
            {
                $listNode->addElement($itemName, $item);
            }
            $this->writeOutput();
        }
        
        public function writeOutput()
        {
            echo $this->xmlDocument->saveXML();
        }    
    }
    
    class XMLList extends DOMElement
    {        
        public function __construct($type) {   
                parent::__construct($type, null, null);     
        }
        
        public function addElement($type, $data)
        {            
            $element = $this->ownerDocument->createElement($type, $data);
            $this->appendChild($element);
        }
                
        public function addList($type)
        {
            $list = new XMLList($type); 
            $this->appendChild($list);            
            
            return $list;
        }
    }
    
?>