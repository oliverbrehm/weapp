<?php

    $xml = new DOMDocument("1.0", "UTF-8");

    function xml_add_response($success, $message = "")
    {
        global $xml;
        
        $node_response = $xml->createElement("response");
        $attr_response_value = $xml->createAttribute("success");
        $attr_response_value->value = json_encode($success);
        $node_response->appendChild($attr_response_value);
        
        $attr_response_text = $xml->createAttribute("message");
        $attr_response_text->value = $message;
        $node_response->appendChild($attr_response_text);
        
        $xml->appendChild($node_response);
    }
    
    function xml_error($message)
    {
        global $xml;
        
        $xml->appendChild(xml_add_response(false, "Error: ".$message));
        xml_send();
    }
    
    function xml_send()
    {
        global $xml;
        
        echo $xml->saveXML();
    }

?>