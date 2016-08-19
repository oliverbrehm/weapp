<?php
    
    include("header.php");
    
    echo '<article>';

?>

    <h1>Invitations</h1>

<?php
    if(UserQuery::queryLoggedIn() == true) {
        echo '
        <a class="action" href="createInvitation.php">Create invitation</a><br>
        <br>
        ';
        
        $invitations = InvitationQuery::queryAll();
                
        foreach($invitations as $invitation) {
            echo "<a class='invitation' href=show_invitation.php?invitation_id=".$invitation->id.">".$invitation->name."</a><br>\n\n";
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