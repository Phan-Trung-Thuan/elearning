<link rel="stylesheet" href="/elearning/style/topnav-style.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.5.0/css/all.css" integrity="sha384-B4dIYHKNBt8Bc12p+WXckhzcICo0wtJAoU8YZTY5qE0Id1GSseTk6S+L3BlXeVIU" crossorigin="anonymous">
<div id="topnav-container">
    <div id="header">
        <div id="header-content">
            <img src="/elearning/img/logo.jpg">
            <span><strong>ELEARNING</strong></span>
        </div>
        <div id="user-account">
            <span><strong><?php echo 'WELCOME ' . $_COOKIE['username']?></strong></span>
            <div id="account-option" class="dropdown">
                <button class="dropbtn"><i class="fa-solid fa-caret-down"></i></button>
                <div class="dropdown-content" id="dropdown-content-account-option">
                    <a id="setting-btn" href="#"><strong>Setting</strong></a>
                    <a id="logout-btn" href="/elearning/login/index.php"><strong>Logout</strong></a>
                </div>
            </div>
        </div>
    </div>
    <div id="topnav">
        <div class="left-div">
            <div id="home-link">
                <a href="/elearning/homepage/home.php"><i class="fa-solid fa-house"></i>&nbsp;<strong>Home</strong></a> 
            </div>   
            <div id="my-class" class="dropdown" >
                <button class="dropbtn"><i class="fa-solid fa-chalkboard-user"></i>&nbsp;<strong>My Classroom</strong></button>
                <div class="dropdown-content" id="dropdown-content-class">
                </div>
            </div>

            <div id="create-class">
                <i class="fa-solid fa-plus"></i>&nbsp;<strong>New Class</strong> 
            </div>  
        </div>
        
        <div class="right-div" id="searching-container">
            <form action="/elearning/search/search.php" method="get" id="search-bar">                
                <input type="text" name="class-title-keyword" id="class-title-keyword" placeholder="Search Class Here">
                <input type="hidden" name="ppage" value="3">
                <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>                
            </form>
        </div>
    </div>
</div>
<input type="hidden" name="username" value="<?php echo $_COOKIE['username'] ?>">
<input type="hidden" name="type" value="<?php echo $_COOKIE['type'] ?>">
<script src="/elearning/topnav/topnav.js" type="module"></script>
<script src="https://kit.fontawesome.com/694106e21d.js" crossorigin="anonymous"></script>
