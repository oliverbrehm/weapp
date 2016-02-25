<?php
    
    include("header.php");
    ?>

<h2>Log out</h2>

<?php
    if(User::queryLoggedIn() == false) {
        echo '
        <p>You are not logged in. Please <a href="login.php">log in</a> or <a href="register.php">sign up</a>.
        ';
    } else {
        if(User::logout() == true) {
            echo '
            <p>Successfully logged out. Please <a href="login.php">log in</a> or <a href="register.php">sign up</a>.
            ';
        } else {
            echo "<p>Error logging out user</p>";
        }
    }
    
    include("footer.php");
?>