<?php
    
    include("header.php");
    ?>

<h2>Friends</h2>

<?php
    if(UserQuery::queryLoggedIn() == true) {
        echo '
        <p>Logged in. </p><br>
        <br>
        <p>List of all users:</p>
        <br>
        ';

        $users = UserQuery::queryAllNames();
        foreach($users as $user) {
            echo '<p>'.$user.'</p><br>';
        }
    } else {
        echo'
        <p>Please <a href="login.php">login</a> to view this section.</p>
        ';
    }
    
    include("footer.php");
?>