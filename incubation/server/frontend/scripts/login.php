<?php
    
    include("../resources/header.php");
    
    if(user_logged_in() == true)
    {
        echo '
<h1>Hi!</h1>
<p>You are logged in. Have a look at the <a href="events.php">events</a> section.</p>
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
<p>Please either login below, or <a href="register.php">click here to sign up</a>.</p>

<form method="post" action="login.php" name="loginform" id="loginform">
<fieldset>
<label for="username">Username:</label><input type="text" name="username" id="username" /><br />
<label for="password">Password:</label><input type="password" name="password" id="password" /><br />
<input type="submit" name="login" id="login" value="Login" />
</fieldset>
</form>
        ';
    }
    
    include("../resources/footer.php");
?>