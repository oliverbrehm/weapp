<?php
    
    include("header.php");
    
    echo '<article>';
    
    if(UserQuery::queryLoggedIn() == true) {
        if(!empty($_POST['name']) && !empty($_POST['description']))
        {
            $name = $_POST['name'];
            $description = $_POST['description'];
            $maxParticipants = $_POST['maxParticipants'];
            $date = $_POST['date'];
            $time = $_POST['time'];
            $locationCity = $_POST['locationCity'];
            $locationStreet = $_POST['locationStreet'];
            $locationStreetNumber = $_POST['locationStreetNumber'];
            $locationLatitude = $_POST['locationLatitude'];
            $locationLongitude = $_POST['locationLongitude'];
        
            if(!InvitationQuery::create($name, $description, $maxParticipants, $date, $time, $locationCity, $locationStreet, $locationStreetNumber, $locationLatitude, $locationLongitude))
            {
                echo "<h1>Invitation not created</h1>";
                echo "<div class='errorMessage'><p>Sorry, There is already an invitation with the same name.</p></div>";
                echo "<a class='action' href=\"createInvitation.php\">Choose another name</a>";
            } else
            {
                echo "<h1>Invitation created</h1>";
                echo "<div class='successMessage'><p>The invitation ".$name." was successfully created.</p></div>";
            }
        }
        else
        {
            echo '
            <h1>Create new invitation</h1>

            <div class="info"><p>Please enter the dinvitation details below.</p></div>

            <form method="post" action="createInvitation.php" name="createInvitationForm" id="createInvitationForm">
                <fieldset>
                    <label for="name">Name:</label><input type="text" name="name" id="name" /><br />
                    <label for="description">Description:</label><textarea name="description" id="description" cols="30" rows="6"></textarea><br />
                    <label for="maxParticipants">Maximum participants:</label><input type="range" min="1" max="32" value="1" name="maxParticipants" id="maxParticipants" oninput="document.getElementById(\'rangevalue\').value=value" /><output id="rangevalue">1</output><br />
                    <label for="date">Date:</label><input type="date" name="date" id="date" /><br />
                    <label for="time">Time:</label><input type="time" name="time" id="time" /><br />
                    <label for="locationCity">City:</label><input type="text" name="locationCity" id="locationCity" /><br />
                    <label for="locationStreet">Street:</label><input type="text" name="locationStreet" id="locationStreet" />
                    <label for="locationStreetNumber">Number:</label><input type="text" name="locationStreetNumber" id="locationStreetNumber" /><br />
                    <label for="locationLatitude">locationLatitude:</label><input type="text" name="locationLatitude" id="locationLatitude" /><br />
                    <label for="locationLongitude">locationLongitude:</label><input type="text" name="locationLongitude" id="locationLongitude" /><br />
                    <input type="submit" name="create_invitation" id="create_invitation" value="Create" />
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