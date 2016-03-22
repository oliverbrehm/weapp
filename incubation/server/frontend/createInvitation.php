<?php
    
    include("header.php");
    
    echo '<article>';
    
    if(UserQuery::queryLoggedIn() == true) {
        if(!empty($_POST['invitation_name']) && !empty($_POST['invitation_description']))
        {
            $invitation_name = $_POST['invitation_name'];
            $invitation_description = $_POST['invitation_description']; // TODO encrypt

            if(!InvitationQuery::create($invitation_name, $invitation_description))
            {
                echo "<h1>Invitation not created</h1>";
                echo "<div class='errorMessage'><p>Sorry, There is already an invitation with the same name.</p></div>";
                echo "<a class='action' href=\"createInvitation.php\">Choose another name</a>";
            } else
            {
                echo "<h1>Invitation created</h1>";
                echo "<div class='successMessage'><p>The invitation ".$invitation_name." was successfully created.</p></div>";
            }
        }
        else
        {
            echo '
            <h1>Create new invitation</h1>

            <div class="info"><p>Please enter the dinvitation details below.</p></div>

            <form method="post" action="createInvitation.php" name="createInvitationForm" id="createInvitationForm">
                <fieldset>
                    <label for="invitation_name">Name:</label><input type="text" name="invitation_name" id="invitation_name" /><br />
                    <label for="invitation_description">Description:</label><textarea name="invitation_description" id="invitation_name" cols="30" rows="6"></textarea><br />
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