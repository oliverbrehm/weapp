<?php
    
    include("header.php");
    
    echo '<article>';

    
    if(empty($_GET['user_id'])) {
        echo "<div class='errorMessage'>No user specified</div>\n";
    } else if(UserQuery::queryLoggedIn() == true) {
        $id = $_GET['user_id'];
       
        $user = UserQuery::queryDetails($id);
                
        echo "<h1>".$user->name."</h1>";
        echo "<div class='info'>Full Name: ".$user->firstName." ".$user->lastName."</div><br>";
        echo "<div class='info'>Type: ".($user->userType == 1 ? "Immigrant" : "Local")."</div><br>";
        echo "<div class='info'>Gender: ".($user->gender == 1 ? "Male" : "Female")."</div><br>";
        echo "<div class='info'>Date of birth: ".$user->dateOfBirth."</div><br>";
        echo "<div class='info'>Nationality: ".$user->nationality."</div><br>";
        echo "<div class='info'>Mail: ".$user->mail."</div><br>";
        if($user->userType == 1) { // Immigrant
            echo "<div class='info'>Date of immigration: ".$user->dateOfImmigration."</div><br>";
        }
        echo "<div class='info'>Location: (".$user->locationLatitude.", ".$user->locationLongitude.")</div><br>";
     
        echo "
            <div class='label'>Invitations by this user: </div><br>\n";
        
        $userInvitations = InvitationQuery::queryByUser($id);
        
        foreach($userInvitations as $invitation) { 
            echo "<a href='show_invitation.php?invitation_id=".$invitation->id."'>".$invitation->name."</a><br>";
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