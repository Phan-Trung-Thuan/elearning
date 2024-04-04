<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/elearning/style/login-style.css">
    <title>Login</title>
</head>
<body>
    <?php
        include __DIR__ . "/../utils/warning-box.php";
    ?>
    <div class="login-box">
        <header>Login</header>
        <form id="login-form">
            <div class="input">
                <label for="username">Username</label>
                <input type="text" name="username" id="username" required>
            </div>

            <div class="input">
                <label for="password">Password</label>
                <input type="password" name="password" id="password" required>
            </div>

            <div class="login-btn">
                <input type="submit" class="btn" name="submit" value="Login">
            </div>

            <!-- <div class="links">
                Don't have account? <a href="register.php">Sign Up Now</a>
            </div> -->
        </form>
    </div>
    <script src="/elearning/login/send_message.js"></script>
</body>
</html>