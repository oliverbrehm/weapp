<html>
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

        <style>

            body{
            margin: 10px auto;
                max-width: 60em;
            }
            * {
            padding: 10px;margin:5px;
            }
            header{
            border: 2px solid #3481cd
            }
            nav{
            background: skyblue;
            }
            footer{
            border: 2px solid seagreen;
            }

            main{
            border: 2px solid hotpink;
            }

            article{
            border: 2px solid purple;
            }
            section{
            border: 2px solid slateblue;
            }
            aside{
            border: 2px solid tomato;
            }

        </style>

        <title>Integrationsprojekt</title>

    </head>
    <body>
        <header>
            <h1>Integrationsprojekt</h1>
            <nav>
                <ul>
                    <li><a href="register.php">Home</a></li>
                    <li><a href="hello.php">Porfolio</a></li>
                    <li><a href="javascript:void(0)">About</a></li>
                    <li><a href="javascript:void(0)">Contact</a></li>
                </ul>
            </nav>
        </header>

        <article>
        <?php
            include "login.php";
        ?>
        </article>

        <footer>
            <p>FOOTER</p>
        </footer>
    </body>

</html>