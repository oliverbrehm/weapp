<?php
    
    include("../resources/header.php");
    ?>

<h2>Friends</h2>

<?php
    if(user_logged_in() == true) {
        echo '
        <p>Logged in. </p><br>
        <br>
        <p>List of all users:</p>
        <br>
        ';

        $users = get_users();
        foreach($users as $user) {
            echo '<p>'.$user.'</p><br>';
        }
    } else {
        echo'
        <p>Please <a href="login.php">login</a> to view this section.</p>
        ';
    }
    
    include("../resources/footer.php");
?>