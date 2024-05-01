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
        <div class="title">HOMEWORK REPORT</div>
        <div class="paragraph">
            Class: <span id="hw-class"></span>
            &nbsp;|&nbsp;
            Title: <span id=hw-title></span>
        </div>
        <div class="paragraph">
            Created date: <span id="hw-createddate"></span>
            &nbsp;|&nbsp;
            Expiration date: <span id=hw-expirationdate></span>
        </div>
        <hr>
        <div class="paragraph">Total students: <span id="total-student"></span></div>
        <div class="paragraph">The number of submitted: <span id="no-submitted"></span></div>
        <div class="paragraph">Submitted rate: <span id="submitted-rate"></span></div>
        <hr>
        <table id="homework-detail">
            <thead>
                <tr>
                    <th id="th1">Student no.</th>
                    <th id="th2">Full name</th>
                    <th id="th3">Date of birth</th>
                    <th id="th4">Completion status</th>
                    <th id="th5">File</th>
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