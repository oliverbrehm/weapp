<?php
    
    include("header.php");
    
    echo '<article>';
    
    if(UserQuery::queryLoggedIn() == true) {
        if(!empty($_POST['event_name']) && !empty($_POST['event_description']))
        {
            $event_name = $_POST['event_name'];
            $event_description = $_POST['event_description']; // TODO encrypt

            if(!EventQuery::create($event_name, $event_description))
            {
                echo "<h1>Event not created</h1>";
                echo "<div class='errorMessage'><p>Sorry, There is already an event with the same name.</p></div>";
                echo "<a class='action' href=\"createEvent.php\">Choose another name</a>";
            } else
            {
                echo "<h1>Event created</h1>";
                echo "<div class='successMessage'><p>The event ".$event_name." was successfully created.</p></div>";
            }
        }
        else
        {
            echo '
            <h1>Create new event</h1>

            <div class="info"><p>Please enter the devent details below.</p></div>

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
        <div class="info"><p>Please <a href="login.php">login</a> to view this section.</p></div>
        ';
    }
    
    echo '</article>';
    
    include("footer.php");
?>