<?php
    
    class Event 
    {
        public static function queryAllIDs() 
        {
            $data = array('action' => 'event_get_all');

            $request = new PostRequest($data);
            $request->execute();

            return explode(';', $request->responseMessage);        
        }

        public static function queryName($id) 
        {
            $data = array('action' => 'event_get_name', 'event_id' => $id);

            $request = new PostRequest($data);
            $request->execute();

            return $request->responseMessage;     
        }

        public static function queryUser($id) 
        {
            $data = array('action' => 'event_get_user', 'event_id' => $id);

            $request = new PostRequest($data);
            $request->execute();

            return $request->responseMessage;     
        }

        public static function queryDescription($id) 
        {
            $data = array('action' => 'event_get_description', 'event_id' => $id);

            $request = new PostRequest($data);
            $request->execute();

            return $request->responseMessage;     
        }

        public static function create($name, $description)
        {
            $data = array('action' => 'event_create', 'event_name' => $name, 'event_description' => $description);

            $request = new PostRequest($data);
            $request->execute();

            return $request->responseValue;
        }
    }
?>