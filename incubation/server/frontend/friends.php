<?php
    
    include("header.php");
    
    echo '<article>';

    ?>

<h1>Users</h1>

<?php
    if(UserQuery::queryLoggedIn() == true) {
        echo '
        <br>
        <h2>List of all users</h2>
        <br>
        ';

        $users = UserQuery::queryAll();
        foreach($users as $user) {
            echo '<a href="show_user.php?user_id='.$user->id.'">'.$user->name.'</a><br>';
        }
        
        echo '<br>';
    } else {
        echo'
        <div class="info"><p>Please login to view this section.</p></div>
        <a href="login.php">Login</a>
        ';
    }
    
    echo '</article>';
    
    include("footer.php");
    
 ?>