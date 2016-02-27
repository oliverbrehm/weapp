<?php
    
    include("header.php");
?>

    <h2>Events</h2>

<?php
    if(UserQuery::queryLoggedIn() == true) {
        echo '
        <p>Logged in.</p>
        <br>
        <a href="createEvent.php">Create event</a><br>
        <br>
        ';
        
        $events = EventQuery::queryAll();
                
        foreach($events as $event) {
            echo "<a href=show_event.php?event_id=".$event->id.">".$event->name."</a><br>\n\n";
        }
    } else {
        echo'
        <p>Please <a href="login.php">login</a> to view this section.</p>
        ';
    }
    
    include("footer.php");
?>