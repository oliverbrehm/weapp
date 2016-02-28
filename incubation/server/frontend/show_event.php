<?php
    
    include("header.php");
    
    echo '<article>';

    
    if(empty($_GET['event_id'])) {
        echo "<div class='errorMessage'><p>No event specified</p></div>\n";
    } else if(UserQuery::queryLoggedIn() == true) {
        $id = $_GET['event_id'];

        if(!empty($_POST['event_comment'])) {
            
            $comment_message = $_POST['event_comment'];

            if(!EventQuery::postComment($id, $comment_message))
            {
                echo "<div class='errorMessage'><p>Error posting comment</p></div>\n";
            }
            else
            {
                echo "<div class='successMessage'><p>Comment posted</p></div>\n";
            }      
        }
        
        
        $event = EventQuery::queryDetails($id);
                
        echo "<h1>".$event->name."</h2>";
        echo "
            <div class='label'>Author</div> <a href='show_user.php?user_id=".$event->ownerId."'>".$event->ownerName."</a><br><br>\n
            <div class='textBlock'>".$event->description."\n</div><br><br>\n
            <div class='label'>Comments</div><br>\n";
        
        $comments = EventQuery::queryComments($id);
        foreach($comments as $comment) {
            echo "<div class='eventComment'>";
            echo "<a href='show_user.php?user_id=".$comment->authorId."'>".$comment->authorName."</a> (".$comment->time."):<br>";
            echo "<div class='textBlock'>".$comment->message."</div></div><br>";
        }
        
        echo "
            <br><div class='label'>Add Comment</div> <br>\n
            <form method='post' action='show_event.php?event_id=".$id."' name='registerform' id='registerform'>
                <fieldset>
                    <label for='event_comment'>Comment:</label><textarea name='event_comment' id='event_comment' cols='30' rows='10'></textarea><br />
                    <input type='hidden' name='event_id' value='".$id."' />
                    <input type='submit' name='event_post' id='event_post' value='Post' />
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