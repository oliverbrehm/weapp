<?php
    
    include("header.php");
    
    if(empty($_GET['event_id'])) {
        echo "<h2>No event specified</h2>\n";
    } else if(UserQuery::queryLoggedIn() == true) {
        $id = $_GET['event_id'];

        if(!empty($_GET['event_comment'])) {
            
            $comment_message = $_GET['event_comment'];

            if(!EventQuery::postComment($id, $comment_message))
            {
                echo "<h3>Error posting comment...</h3>\n";
            }
            else
            {
                echo "<h3>Comment posted...</h3>\n";
            }      
        }
        
        
        $event = EventQuery::queryDetails($id);
                
        echo "<h2>".$event->name."</h2>";
        echo "
            Author: ".$event->ownerName." <br><br>\n
            Description: <br><br>\n".$event->description."\n<br><br>\n
            Comments: <br><br>\n";
        
        $comments = EventQuery::queryComments($id);
        foreach($comments as $comment) {
            echo $comment->author."(".$comment->time."):<br>";
            echo "<p>".$comment->message."</p><br><br>";
        }
        
        echo "
            <br>Add Comment: <br>\n
            <form method='get' action='show_event.php?event_id=".$id."' name='registerform' id='registerform'>
                <fieldset>
                    <label for='event_comment'>Comment:</label><textarea name='event_comment' id='event_comment' cols='30' rows='10'></textarea><br />
                    <input type='hidden' name='event_id' value='".$id."' />
                    <input type='submit' name='event_post' id='event_post' value='Post' />
                </fieldset>
            </form>";    
        
        
    } else {
        echo'
        <p>Please <a href="login.php">login</a> to view this section.</p>
        ';
    }
    
    include("footer.php");
?>