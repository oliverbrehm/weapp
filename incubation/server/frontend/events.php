<?php
    
    include("header.php");
?>

    <h2>Events</h2>

<?php
    if(user_logged_in() == true) {
        echo '
        <p>Logged in. TBD list events.</p>
        ';
    } else {
        echo'
        <p>Please <a href="login.php">login</a> to view this section.</p>
        ';
    }
    
    include("footer.php");
?>