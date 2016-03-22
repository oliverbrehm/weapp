<?php
    
    include("header.php");
    
    echo '<article>';

    
    if(empty($_GET['invitation_id'])) {
        echo "<div class='errorMessage'><p>No invitation specified</p></div>\n";
    } else if(UserQuery::queryLoggedIn() == true) {
        $id = $_GET['invitation_id'];

        if(!empty($_POST['invitation_comment'])) {
            
            $comment_message = $_POST['invitation_comment'];

            if(!InvitationQuery::postComment($id, $comment_message))
            {
                echo "<div class='errorMessage'><p>Error posting comment</p></div>\n";
            }
            else
            {
                echo "<div class='successMessage'><p>Comment posted</p></div>\n";
            }      
        }
        
        
        $invitation = InvitationQuery::queryDetails($id);
                
        echo "<h1>".$invitation->name."</h2>";
        echo "
            <div class='label'>Author</div> <a href='show_user.php?user_id=".$invitation->ownerId."'>".$invitation->ownerName."</a><br><br>\n
            <div class='textBlock'>".$invitation->description."\n</div><br><br>\n
            <div class='label'>Comments</div><br>\n";
        
        $comments = InvitationQuery::queryComments($id);
        foreach($comments as $comment) {
            echo "<div class='invitationComment'>";
            echo "<a href='show_user.php?user_id=".$comment->authorId."'>".$comment->authorName."</a> (".$comment->time."):<br>";
            echo "<div class='textBlock'>".$comment->message."</div></div><br>";
        }
        
        echo "
            <br><div class='label'>Add Comment</div> <br>\n
            <form method='post' action='show_invitation.php?invitation_id=".$id."' name='registerform' id='registerform'>
                <fieldset>
                    <label for='invitation_comment'>Comment:</label><textarea name='invitation_comment' id='invitation_comment' cols='30' rows='10'></textarea><br />
                    <input type='hidden' name='invitation_id' value='".$id."' />
                    <input type='submit' name='invitation_post' id='invitation_post' value='Post' />
                </fieldset>
            </form>";    
        
        
    } else {
        echo'
        <div class="info"><p>Please login to view this section.</p></div>
        <a href="login.php">Login</a>
        ';
    }
    
    echo '</article>';
    
    include("footer.php");
    
 ?>