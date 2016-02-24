<?php
    
    include("header.php");
?>

    <h2>Events</h2>

<?php
    if(user_logged_in() == true) {
        echo '
        <p>Logged in.</p>
        <br>
        <a href="createEvent.php">Create event</a><br>
        <br>
        ';
        
        $events = get_events();
                
        foreach($events as $event_id) {
            $event_name = event_get_name($event_id);
            echo "<a href=show_event.php?event_id=".$event_id.">".$event_name."</a><br>\n\n";
        }
    } else {
        echo'
        <p>Please <a href="login.php">login</a> to view this section.</p>
        ';
    }
    
    include("footer.php");
?>