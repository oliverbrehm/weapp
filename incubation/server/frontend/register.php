<?php
    
    include("header.php");
    
    echo '<article>';

        
    if(!empty($_POST['username']) && !empty($_POST['password']))
    {
        $username = $_POST['username'];
        $password = $_POST['password']; // TODO encrypt
        
        if(!UserQuery::register($username, $password))
        {
            echo "<h1>Error</h1>";
            echo "<div class='errorMessage'><p>Sorry, that username is taken.</p></div>";
            echo "<a href=\"register.php\">Choose another name</a>";
        }
        else
        {
            echo "<h1>Success</h1>";
            echo "<div class='successMessage'><p>Your account was successfully created.</p></div>";
            echo ' <a href="login.php">Log in</a>';
        }
    }
    else
    {
        echo '
        <h1>Sign up</h1>
        
        <div class="info"><p>Please enter your details below to sign up.</p></div>
        
        <form method="post" action="register.php" name="registerform" id="registerform">
            <fieldset>
                <label for="username">Username:</label><input type="text" name="username" id="username" /><br />
                <label for="password">Password:</label><input type="password" name="password" id="password" /><br />
                <input type="submit" name="register" id="register" value="Register" />
            </fieldset>
        </form>
        ';
    }
    
    echo '</article>';
    
    include("footer.php");
    
 ?>