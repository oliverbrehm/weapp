<?php
    
    include("header.php");
        
    if(!empty($_POST['username']) && !empty($_POST['password']))
    {
        $username = $_POST['username'];
        $password = $_POST['password']; // TODO encrypt
        
        if(!User::register($username, $password))
        {
            echo "<h1>Error</h1>";
            echo "<p>Sorry, that username is taken. Please go <a href=\"register.php\">back</a> and try again.</p>";
        }
        else
        {
            echo "<h1>Success</h1>";
            echo "<p>Your account was successfully created. Please <a href=\"login.php\">click here to login</a>.</p>";
        }
    }
    else
    {
        echo '
        <h1>Register</h1>
        
        <p>Please enter your details below to register.</p>
        
        <form method="post" action="register.php" name="registerform" id="registerform">
            <fieldset>
                <label for="username">Username:</label><input type="text" name="username" id="username" /><br />
                <label for="password">Password:</label><input type="password" name="password" id="password" /><br />
                <input type="submit" name="register" id="register" value="Register" />
            </fieldset>
        </form>
        ';
    }
    
    include("footer.php");
?>