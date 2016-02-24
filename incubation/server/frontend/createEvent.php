<?php
    
    include("header.php");
    
    if(user_logged_in() == true) {
        if(!empty($_POST['event_name']) && !empty($_POST['event_description']))
        {
            $event_name = $_POST['event_name'];
            $event_description = $_POST['event_description']; // TODO encrypt

            if(!event_create($event_name, $event_description))
            {
                echo "<h2>Error</h2>";
                echo "<p>Sorry, There is already an event with the same name. Please go <a href=\"createEvent.php\">back</a> and choose another name.</p>";
            } else
            {
                echo "<h2>Success</h2>";
                echo "<p>The event ".$event_name." was successfully created.</p>";
            }
        }
        else
        {
            echo '
            <h1>Create new event</h1>

            <p>Please enter the devent details below.</p>

            <form method="post" action="createEvent.php" name="createEventForm" id="createEventForm">
                <fieldset>
                    <label for="event_name">Name:</label><input type="text" name="event_name" id="event_name" /><br />
                    <label for="event_description">Description:</label><textarea name="event_description" id="event_name" cols="30" rows="6"></textarea><br />
                    <input type="submit" name="create_event" id="create_event" value="Create" />
                </fieldset>
            </form>
            ';
        }
    } else {
        echo'
        <p>Please <a href="login.php">login</a> to view this section.</p>
        ';
    }
    
    include("footer.php");
?>