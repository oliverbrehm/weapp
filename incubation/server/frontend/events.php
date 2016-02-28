<?php
    
    include("header.php");
    
    echo '<article>';

?>

    <h1>Events</h1>

<?php
    if(UserQuery::queryLoggedIn() == true) {
        echo '
        <a class="action" href="createEvent.php">Create event</a><br>
        <br>
        ';
        
        $events = EventQuery::queryAll();
                
        foreach($events as $event) {
            echo "<a class='event' href=show_event.php?event_id=".$event->id.">".$event->name."</a><br>\n\n";
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