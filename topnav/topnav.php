<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Topnav</title>
    <link rel="stylesheet" href="/elearning/style/topnav-style.css">
    <script src="https://kit.fontawesome.com/694106e21d.js" crossorigin="anonymous"></script>    
</head>
<body>
    <div id="topnav-container">
        <div id="header">HEADER GOES HERE (ICON, ACCOUNT,...)</div>
        <div id="topnav">
            <a href="home.php">Home</a>            
            <div class="dropdown" >
                <button class="dropbtn">My Classroom</button>
                <div class="dropdown-content" id="dropdown-content-class">
                </div>
            </div>
            <form action="search.php" method="get" id="search-bar">                
                <input type="text" name="class-title-keyword" id="class-title-keyword" placeholder="Search Class Here">
                <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>                
            </form>            
        </div>        
    </div>    
    
    <script src="/elearning/topnav/topnav.js"></script>
</body>
</html>

