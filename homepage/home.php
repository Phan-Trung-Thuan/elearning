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
        # Check login cookie
        if (!isset($_COOKIE["type"])) {
            header("Location: /elearning/login/index.php");
        }
        
        include __DIR__ . '/../topnav/topnav.html';
    ?>

    <div id="homepage-container">
        This is body
    </div>

    <!-- <script src="/elearning/homepage/check_session.js"></script> -->
</body>
</html>