<?php
    
    include("header.php");
    
    if(empty($_GET['event_id'])) {
        echo "<h2>No event specified</h2>\n";
    } else if(user_logged_in() == true) {
        $id = $_GET['event_id'];
                
        echo "<h2>".event_get_name($id)."</h2>";
        echo "
        Author: ".event_get_user($id)." <br>\n
        Description: <br><br>\n".  event_get_description($id)."\n<br><br>\n";     
    } else {
        echo'
        <p>Please <a href="login.php">login</a> to view this section.</p>
        ';
    }
    
    include("footer.php");
?>