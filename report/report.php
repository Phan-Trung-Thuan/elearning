<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HOMEPAGE</title>
    <link rel="stylesheet" href="/elearning/style/main-style.css">
    
</head>
<body>
    <?php
        include __DIR__ . '/../utils/functions.php';

        $result = null;
        if (!(isset($_COOKIE["username"]) && isset($_COOKIE["password"]) && isset($_COOKIE["type"]) 
                                        && checkLogin($_COOKIE["username"], $_COOKIE["password"]))) {
            header("Location: /elearning/login/index.php");
        }
        
        include __DIR__ . '/../topnav/topnav.php';
    ?>

    <div id="main-container">

    </div>
    
    <input type="hidden" name="cell-id" id="cell-id" value="<?php echo $_POST['cell-id'] ?>">
    <script type="module" src="/elearning/report/report.js"></script>
    <!-- <script src="/elearning/homepage/check_session.js"></script> -->
</body>
</html>