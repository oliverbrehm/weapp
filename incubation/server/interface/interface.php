<?php
    error_reporting(-1);
    ini_set('display_errors', 'On');
    
    if(session_id() == '' || !isset($_SESSION)) {
        session_start();
    }
    
    require_once('xml_response.php');
    require_once('authentication.php');
    
    $action = $_POST["action"];

    if($action == "user_register") {
        if(empty($_POST["username"]) || empty($_POST["password"])) {
            error("Username or password not specified");
        } else {
            $username = $_POST['username'];//);
            $password = $_POST['password'];//); TODO encrypt
            
            user_register($username, $password);
        }
    } else if($action == "user_login") {
        if(empty($_POST["username"]) || empty($_POST["password"])) {
            error("Username or password not specified");
        } else {
            //$username = mysql_real_escape_string($_POST['username']);
            //$password = md5(mysql_real_escape_string($_POST['password']); //TODO encrypt
            
            $username = $_POST['username'];
            $password = $_POST['password'];
            
            user_login($username, $password);
        }
    } else if($action == "user_logout") {
        user_logout();
    } else if($action == "user_logged_in") {
        user_logged_in();
    } else if($action == "say_hello") {
        say_hello();
    } else {
        no_action();
    }
?>