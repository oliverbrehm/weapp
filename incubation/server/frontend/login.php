<?php
    
    include("header.php");
    
    require_once("common.php");
    
    if(user_logged_in() == true)
    {
        echo '
<h1>Member Area</h1>
<pThanks for logging in!</p>
        ';
    }
    else if(!empty($_POST['username']) && !empty($_POST['password']))
    {
        $username = $_POST['username'];
        $password_cleartext = $_POST['password'];
        if(user_login($username, $password_cleartext) == true) {
            echo "<h1>Login successful</h1>";
        } else {
            echo "<h1>Login failed</h1>";
        }
    }
    else
    {
        echo '
<h1>Member Login</h1>

<p>Thanks for visiting! Please either login below, or <a href="register.php">click here to register</a>.</p>

<form method="post" action="index.php" name="loginform" id="loginform">
<fieldset>
<label for="username">Username:</label><input type="text" name="username" id="username" /><br />
<label for="password">Password:</label><input type="password" name="password" id="password" /><br />
<input type="submit" name="login" id="login" value="Login" />
</fieldset>
</form>
        ';
    }
    
    include("footer.php");
?>