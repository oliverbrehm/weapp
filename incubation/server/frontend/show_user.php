<?php
    
    include("header.php");
    
    echo '<article>';

    
    if(empty($_GET['user_id'])) {
        echo "<div class='errorMessage'>No user specified</div>\n";
    } else if(UserQuery::queryLoggedIn() == true) {
        $id = $_GET['user_id'];
       
        $user = UserQuery::queryDetails($id);
                
        echo "<h1>".$user->name."</h1>";
        echo "<div class='info'>TBD user info</div><br>";
        echo "
            <div class='label'>Events by this user: </div><br>\n";
        
        $userEvents = EventQuery::queryByUser($id);
        
        foreach($userEvents as $event) { 
            echo "<a href='show_event.php?event_id=".$event->id."'>".$event->name."</a><br>";
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