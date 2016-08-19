<?php
    
    include("header.php");
    
    echo '<article>';

    ?>

<h2>Log out</h2>

<?php
    if(UserQuery::queryLoggedIn() == false) {
        echo '
        <div class="info"><p>You are not logged in. Please sign up login.</div>
        <a href="login.php">Log in</a> 
        <a href="register.php">Sign up</a>
        ';
    } else {
        if(UserQuery::logout() == true) {
            echo '
            <div class="successMessage"><p>Successfully logged out.</div>
            <a href="login.php">Log in</a> 
            ';
        } else {
            echo "<div class='errorMessage'><p>Error logging out user</p></div>";
        }
    }
    
    echo '</article>';
    
    include("footer.php");
    
 ?>