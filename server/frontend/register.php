<?php
    
    include("header.php");
    
    echo '<article>';

        
    if(!empty($_POST['username']) && !empty($_POST['password']))
    {
        $username = $_POST['username'];
        $password = $_POST['password']; // TODO encrypt
        $firstName = $_POST['firstName'];
        $lastName = $_POST['lastName'];
        
        $userTypeText = $_POST['userType'];
        $userType = ($userTypeText == "immigrant" ) ? 1 : 0;
        
        $genderText = $_POST['gender'];
        $gender = ($genderText == "male" ) ? 1 : 0;

        $dateOfBirth = $_POST['dateOfBirth'];
        $nationality = $_POST['nationality'];
        $mail = $_POST['mail'];
        $dateOfImmigration = $_POST['dateOfImmigration'];
        $locationLatitude = $_POST['locationLatitude'];
        $locationLongitude = $_POST['locationLongitude'];
                
        if(!UserQuery::register($username, $password,$firstName, $lastName, $userType, $gender, $dateOfBirth, $nationality, $mail, $dateOfImmigration, $locationLatitude, $locationLongitude))
        {
            echo "<h1>Error</h1>";
            echo "<div class='errorMessage'><p>Sorry, that username is taken.</p></div>";
            echo "<a href=\"register.php\">Choose another name</a>";
        }
        else
        {
            echo "<h1>Success</h1>";
            echo "<div class='successMessage'><p>Your account was successfully created.</p></div>";
            echo ' <a href="login.php">Log in</a>';
        }
    }
    else
    {
        echo '
        <h1>Sign up</h1>
        
        <div class="info"><p>Please enter your details below to sign up.</p></div>
        
        <form method="post" action="register.php" name="registerform" id="registerform">
            <fieldset>
                <label for="username">Username:</label><input type="text" name="username" id="username" /><br />
                <label for="password">Password:</label><input type="password" name="password" id="password" /><br />
                <label for="firstName">First name:</label><input type="text" name="firstName" id="firstName" /><br />
                <label for="lastName">Last name:</label><input type="text" name="lastName" id="lastName" /><br />
                <label for="userType">I am:</label>
                    <input type="radio" name="userType" id="userType" value="immigrant" checked> Immigrant
                    <input type="radio" name="userType" id="userType" value="local"> Local<br><br />
                <label for="gender">Gender:</label>
                    <input type="radio" name="gender" id="gender" value="male" checked> Male
                    <input type="radio" name="gender" id="gender" value="female"> Female<br><br />
                <label for="dateOfBirth">Date of birth:</label><input type="date" name="dateOfBirth" id="dateOfBirth" /><br />
                <label for="nationality">Nationality:</label><input type="text" name="nationality" id="nationality" /><br />
                <label for="mail">Mail:</label><input type="mail" name="mail" id="mail" /><br />
                <label for="dateOfImmigration">Date of immigration:</label><input type="date" name="dateOfImmigration" id="dateOfImmigration" /><br />
                <label for="locationLatitude">Longitude:</label><input type="text" name="locationLatitude" id="locationLatitude" /><br />
                <label for="locationLongitude">Latitude:</label><input type="text" name="locationLongitude" id="locationLongitude" /><br />
                <input type="submit" name="register" id="register" value="Register" />
            </fieldset>
        </form>
        ';
    }
    
    echo '</article>';
    
    include("footer.php");
    
 ?>