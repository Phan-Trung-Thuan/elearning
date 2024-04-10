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
        session_start();
        # Check login session
        if (!isset($_SESSION["type"])) {
            header("Location: /elearning/login/index.php");
            exit;
        }
        
        include __DIR__ . '/../topnav/topnav.html';
    ?>

    <div id="homepage-container">
        This is body
    </div>

    <script src="/elearning/homepage/check_session.js"></script>
</body>
</html>