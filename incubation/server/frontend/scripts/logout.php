<?php
    
    include("../resources/header.php");
    ?>

<h2>Log out</h2>

<?php
    if(user_logged_in() == false) {
        echo '
        <p>You are not logged in. Please <a href="login.php">log in</a> or <a href="register.php">sign up</a>.
        ';
    } else {
        if(user_logout() == true) {
            echo '
            <p>Successfully logged out. Please <a href="login.php">log in</a> or <a href="register.php">sign up</a>.
            ';
        } else {
            echo "<p>Error logging out user</p>";
        }
    }
    
    include("../resources/footer.php");
?>