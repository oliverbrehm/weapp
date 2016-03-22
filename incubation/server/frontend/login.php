<?php
    
    include("header.php");
    
    echo '<article>';

    
    if(UserQuery::queryLoggedIn() == true)
    {
        echo '
<h1>Logged in</h1>
<div class="info"><p>You are logged in. Have a look at the invitation section.</p><div>
<a href="invitations.php">Invitations</a>
<br>
<a href="logout.php">Logout</a>
        ';
    }
    else if(!empty($_POST['username']) && !empty($_POST['password']))
    {
        $username = $_POST['username'];
        $password_cleartext = $_POST['password'];
        if(UserQuery::login($username, $password_cleartext) == true) {
            echo '<h1>Login successful</h1>
            <a href="invitations.php">Invitations</a>
            <br>
            <a href="logout.php">Logout</a>';
        } else {
            echo "<h1>Login failed</h1>";
            echo "<br><a href='login.php'>Try again</a>";
        }
    }
    else
    {
        echo '
<h1>Member Login</h1>

<div class="info"><p>Enter your login information below</p></div>
<form method="post" action="login.php" name="loginform" id="loginform">
    <fieldset>
        <label for="username">Username:</label><input type="text" name="username" id="username" /><br />
        <label for="password">Password:</label><input type="password" name="password" id="password" /><br />
        <input type="submit" name="login" id="login" value="Login" />
    </fieldset>
</form>

<div class="info"><p>No account yet?</p></div>
<a href="register.php">Sign up</a>
        ';
    }
    
    echo '</article>';
    
    include("footer.php");
    
 ?>