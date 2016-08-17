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
