<?php

    class PostRequest
    {
        private static $apiUrl = 'http://vocab-book.com/integrationsprojekt/interface/API.php';      
      
        private $postData;
        
        public $response;
        public $responseValue;
        public $responseMessage;
        
        public function __construct($postData) {
            $this->postData = $postData;
        }

        function execute()
        {
            if(isset($_SESSION['interface_cookie'])) {
                // cookie set
                //echo 'old cookie: '.$_SESSION['interface_cookie']."\n\n";
            }
            
            // Get cURL resource
            $curl = curl_init();

            $cookie = "";
            if(isset($_SESSION['interface_cookie'])) {
                 $cookie = $_SESSION['interface_cookie'];
            }
            // Set some options - we are passing in a useragent too here
            curl_setopt_array($curl, array(
                                           CURLOPT_RETURNTRANSFER => 1,
                                           CURLOPT_URL => PostRequest::$apiUrl,
                                           CURLOPT_USERAGENT => 'Codular Sample cURL Request',
                                           CURLOPT_POST => 1,
                                           CURLOPT_POSTFIELDS => $this->postData,
                                           CURLOPT_HTTPHEADER => array("Cookie: ".$cookie)
                                           ));

            // execute request (for pure xml without header)
            $resp = curl_exec($curl);

            // repeat request requiring header information
            curl_setopt($curl, CURLOPT_HEADER, 1);
            $resp_header = curl_exec($curl);

            // search and save cookie
            preg_match('/^Set-Cookie:\s*([^\r\n]*)/mi', $resp_header, $cookies);

            if(!isset($_SESSION['interface_cookie'])) {
                $_SESSION['interface_cookie'] = $cookies[1];
            }
            // Close request to clear up some resources
            curl_close($curl);

            echo "\n<!--\nRESPONSE:\n".$resp."\n-->\n";
            
            $this->response = $resp;

            $this->responseMessage = $this->readResponseMessage();
            $this->responseValue = $this->readResponseValue();
            
            return $resp;
        }

        private function readResponseMessage()
        {
            $xml = new DOMDocument();
            $xml->loadXML($this->response);

            $response_nodes = $xml->getElementsByTagName("response");

            if($response_nodes->length > 0) {
                $response_node = $response_nodes->item(0);
                return $response_node->getAttribute("message");
            }

            return "";
        }

        private function readResponseValue()
        {
            $xml = new DOMDocument();
            $xml->loadXML($this->response);

            $response_nodes = $xml->getElementsByTagName("response");

            if($response_nodes->length > 0) {
                $response_node = $response_nodes->item(0);
                $r = $response_node->getAttribute("success");
                if($r === "true") {
                    return true;
                } else {
                    return false;
                }
            }

            return false;
        }
    }
    
?>