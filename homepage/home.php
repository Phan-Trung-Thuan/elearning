<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HOMEPAGE</title>
    <link rel="stylesheet" href="/elearning/style/home-style.css">
    
</head>
<body>
    <?php
        include __DIR__ ."/../utils/check-login.php";

        if (isset($_COOKIE["username"]) && isset($_COOKIE["password"]) && isset($_COOKIE["type"])) {
            $response = check_login($_COOKIE["username"], $_COOKIE["password"]);
        }

        if ($response == "FAIL") {
            header("Location: /elearning/login/index.php");
        }
        
        include __DIR__ . '/../topnav/topnav.php';
    ?>

    <div id="homepage-container">
        
    </div>

    <!-- <script src="/elearning/homepage/check_session.js"></script> -->
</body>
</html>