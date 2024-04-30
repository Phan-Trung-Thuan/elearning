<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HOMEPAGE</title>
    <link rel="stylesheet" href="/elearning/style/main-style.css">
    <link rel="stylesheet" href="/elearning/style/report-style.css">
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
        <h2>HOMEWORK REPORT</h2>
        <div>
            Class: <span id="hw-class"></span>
            &nbsp;|&nbsp;
            Title: <span id=hw-title></span>
        </div>
        <div>
            Created date: <span id="hw-createddate"></span>
            &nbsp;|&nbsp;
            Expiration date: <span id=hw-expirationdate></span>
        </div>
        <hr>
        <div>Total students: <span id="total-student"></span></div>
        <div>The number of submitted: <span id="no-submitted"></span></div>
        <div>Submitted rate: <span id="submitted-rate"></span></div>
        <hr>
        <table id="homework-detail">
            <thead>
                <tr>
                    <th>Student no.</th>
                    <th>Full name</th>
                    <th>Date of birth</th>
                    <th>Completion status</th>
                    <th>File</th>
                </tr>
            </thead>
            <tbody>

            </tbody>
        </table>
    </div>
    
    <input type="hidden" name="cell-id" id="cell-id" value="<?php echo $_POST['cell-id'] ?>">
    <script type="module" src="/elearning/report/report.js"></script>

    <script src="/elearning/utils/third-party/jszip.js"></script>
    <script src="/elearning/utils/third-party/file-saver.js"></script>

    <!-- <script src="/elearning/homepage/check_session.js"></script> -->
</body>
</html>