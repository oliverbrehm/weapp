<?php
    error_reporting(-1);
    ini_set('display_errors', 'On');
    
    if(session_id() == '' || !isset($_SESSION)) {
        session_start();
    }
    
    require_once('classes/PostRequest.php');
    require_once('classes/EventQuery.php');
    require_once('classes/UserQuery.php');
?>

<html>

<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>

<style>

    body{
        margin: 10px auto;
        max-width: 60em;
    }
    * {
        padding: 5px;margin:3px;
    }
    
    header{
        border: 2px solid #3481cd;
    }
    nav{
        background: skyblue;
    }
    footer{
        border: 2px solid seagreen;
    }

    main{
        border: 2px solid hotpink;
    }

    article{
        border: 2px solid purple;
    }
    section{
        border: 2px solid slateblue;
    }
    aside{
        border: 2px solid tomato;
    }
    
    ul {
        display: flex;
        flex-wrap: wrap;
    }
    
    li {
        list-style-type: none;
    }

</style>

<title>Integrationsprojekt</title>

</head>

<body>
<header>
<h1>Integrationsprojekt</h1>
<nav>
<ul>
<li><a href="index.php">Home</a></li>
<li><a href="friends.php">Friends</a></li>
<li><a href="events.php">Events</a></li>
<li><a href="login.php">Login</a></li>
<li><a href="register.php">Sign up</a></li>
<li><a href="logout.php">Log out</a></li>

</ul>
</nav>
</header>
