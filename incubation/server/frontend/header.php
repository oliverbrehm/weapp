<?php
    error_reporting(-1);
    ini_set('display_errors', 'On');
    
    if(session_id() == '' || !isset($_SESSION)) {
        session_start();
    }
    
    require_once('classes/PostRequest.php');
    require_once('classes/InvitationQuery.php');
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
        margin: 10px;
    }
    section{
        border: 2px solid slateblue;
    }
    aside{
        border: 2px solid tomato;
    }
    
    h1 {
        text-align: center;
    }
    
    h2 {
        color: darkslategray;
        font-size: 22;
    }
    
    ul {
        display: flex;
        flex-wrap: wrap;
    }
    
    li {
        list-style-type: none;
    }
    
    a {
        color: green;
        margin: 5px;
        text-decoration: none;
        border: 1px solid greenyellow;
    }
    
    p {
        margin: 5px;
    }
    
    .action {
        margin: 10px;
        border: 4px solid red;
    }
    
    .errorMessage {
        color: darkred;      
    }
    
    .successMessage {
        color: green;
    }
    
    .info {
        font-family: sans-serif;
    }
    
    .invitationComment {
        margin: 10px;
        padding: 3px;
        border: 3px solid coral;
        background: lightgoldenrodyellow;
    }
    
    .label {
        margin: 5px;
        color: darkslategrey;
    }
    
    .textBlock {
        margin: 5px;
        padding: 5px;
        white-space: pre;
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
<li><a href="friends.php">Users</a></li>
<li><a href="invitations.php">Invitations</a></li>
<li><a href="login.php">Login</a></li>
<li><a href="register.php">Sign up</a></li>
<li><a href="logout.php">Log out</a></li>

</ul>
</nav>
</header>
