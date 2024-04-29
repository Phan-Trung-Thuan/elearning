<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Class</title>
    <link rel="stylesheet" href="/elearning/style/main-style.css">
    <link rel="stylesheet" href="/elearning/style/class-style.css">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.5.0/css/all.css" integrity="sha384-B4dIYHKNBt8Bc12p+WXckhzcICo0wtJAoU8YZTY5qE0Id1GSseTk6S+L3BlXeVIU" crossorigin="anonymous">
</head>
<body>
    <?php
        include __DIR__ . '/../utils/functions.php';

        $result = null;
        if (!(isset($_COOKIE["username"]) && isset($_COOKIE["password"]) && isset($_COOKIE["type"]) 
                                        && checkLogin($_COOKIE["username"], $_COOKIE["password"]))) {
            header("Location: /elearning/login/index.php");
        }

        $login_type = $_COOKIE["type"];
        if ($login_type === "STUDENT") {
            if (!isEnrolled()) {
                $redirect_url = "/elearning/homepage/home.php";
                header("Location: $redirect_url");
            }    
        } else if ($login_type === "INSTRUCTOR") {
            if (!isBelong()) {
                $redirect_url = "/elearning/homepage/home.php";
                header("Location: $redirect_url");
            }
        }
        
        include __DIR__ . '/../topnav/topnav.php';
                        
    ?>

    <div id="main-container">
        <div id="container-header">
            <label id="class-name"></label>
            <button id="leave-button" class="button">Leave <i class="fa-solid fa-right-from-bracket"></i></button>
            <button id="open-form-button" class="button">Create Cell <i class="fa-solid fa-circle-plus"></i></button>
        </div>   
        <div id="class-cell-container">
            <template id="notification-cell-template">
                <div class="notification-cell cell" id="${cell_id}">
                    <div class="notification-cell-title title">${cell_title}</div>

                    <div class="notification-cell-desc desc">${cell_description}</div>
                    
                    <div class="document-file" id="document-file-${cell_id}">
                    <hr>
                        <div class="small-title">DOCUMENT</div>
                        <form class="document-input-form file-input-form" id="document-input-form-${cell_id}" method="POST" enctype="multipart/form-data" action="/elearning/utils/execute-request.php">
                            <input type="hidden" name="cell-id" value="${cell_id}">
                            <input type="hidden" name="cell-type" value="document">
                            <input type="file" name="file[]" class="document-file-upload" multiple>                   
                            <button class="upload-button button">Upload <i class="fa-solid fa-cloud-arrow-up"></i></button>
                        </form>

                        <form class="document-output-form file-output-form" id="document-output-form-${cell_id}" method="POST" action="/elearning/utils/execute-request.php">
                            <input type="hidden" name="cell-id" value="${cell_id}">
                            <input type="hidden" name="cell-type" value="document">
                            <ul class="homework-list" id="homework-list-${cell_id}"></ul>
                            <button class="cancel-button button">Cancel</button>
                        </form>
                    <hr>
                    </div>

                    <div class="notification-cell-note note" id="notification-cell-note-${cell_id}">${notification_note}</div>
                    
                    <form class="delete-form" id="delete-form-${cell_id}" method="POST" action="/elearning/utils/execute-request.php">
                        <input type="hidden" name="cell-id" value="${cell_id}">
                        <button class="delete-button button">Delete <i class="fa-solid fa-trash"></i></button>
                    </form>
                </div>
            </template>

            <template id="homework-cell-template">
                <div class="homework-cell cell" id="${cell_id}">
                    <div class="homework-cell-title title">${cell_title}</div>
                    <div class="homework-cell-desc desc">${cell_description}</div>
                    
                    
                    <div class="document-file" id="document-file-${cell_id}">
                    <hr>
                        <div class="small-title">DOCUMENT</div>
                        <form class="document-input-form file-input-form" id="document-input-form-${cell_id}" method="POST" enctype="multipart/form-data" action="/elearning/utils/execute-request.php">
                            <input type="hidden" name="cell-id" value="${cell_id}">
                            <input type="hidden" name="cell-type" value="document">
                            <input type="file" name="file[]" class="document-file-upload" multiple>                   
                            <button class="upload-button button">Upload <i class="fa-solid fa-cloud-arrow-up"></i></button>
                        </form>

                        <form class="document-output-form file-output-form" id="document-output-form-${cell_id}" method="POST" action="/elearning/utils/execute-request.php">
                            <input type="hidden" name="cell-id" value="${cell_id}">
                            <input type="hidden" name="cell-type" value="document">
                            <ul class="homework-list" id="homework-list-${cell_id}"></ul>
                            <button class="cancel-button button">Cancel</button>
                        </form>
                    <hr>
                    </div>

                    <div class="homework-file" id="homework-file-${cell_id}">
                    <hr>
                        <div class="small-title">HOMEWORK</div>
                        <form class="homework-input-form file-input-form" id="homework-input-form-${cell_id}" method="POST" enctype="multipart/form-data" action="/elearning/utils/execute-request.php">
                            <input type="hidden" name="cell-id" value="${cell_id}">
                            <input type="hidden" name="cell-type" value="homework">
                            <input type="file" name="file[]" class="homework-file-upload" multiple>                   
                            <button class="upload-button button">Upload <i class="fa-solid fa-cloud-arrow-up"></i></button>
                        </form>

                        <form class="homework-output-form file-output-form" id="homework-output-form-${cell_id}" method="POST" action="/elearning/utils/execute-request.php">
                            <input type="hidden" name="cell-id" value="${cell_id}">
                            <input type="hidden" name="cell-type" value="homework">
                            <ul class="homework-list" id="homework-list-${cell_id}"></ul>
                            <button class="cancel-button button">Cancel</button>
                        </form>
                        <div class="homework-cell-expiration-date">Expiration date: ${homework_expirationdate}</div>
                    <hr>                        
                    </div>
                                       
                    <div class="homework-progress" id="homework-progress-${cell_id}">
                    <hr>
                        <div class="small-title">HOMEWORK PROGRESS <i>instructor only</i></div>
                        <form class="homework-progress-form" id="homwork-progress-form-${cell_id}" method="POST" action="">
                            <input type="hidden" name="cell-id" value="${cell_id}">
                            <button class="check-homework-button button">Check Homework</button>
                        </form>
                    <hr>
                    </div>
                    
                    <form class="delete-form" id="delete-form-${cell_id}" method="POST" action="/elearning/utils/execute-request.php">
                        <input type="hidden" name="cell-id" value="${cell_id}">
                        <button class="delete-button button">Delete <i class="fa-solid fa-trash"></i></button>
                    </form>
                </div>
            </template>        
        </div>

        <div id="create-cell-form-container">
            <form action="/elearning/utils/execute-request.php" method="POST" id="create-cell-form">
                <h2>Create Cell</h2>

                <label for="cell-title">Title(*)</label>
                <input type="text" name="cell-title" id="cell-title" placeholder="Enter Title" required>

                <label for="cell-description">Description(*)</label>
                <textarea type="text" name="cell-description" id="cell-description" placeholder="Enter description" rows="10" cols="35" required></textarea>

                <label for="cell-type">Choose Type(*)</label>
                <select name="cell-type" id="cell-type" required>
                    <option disabled selected value>-- select an option --</option>
                    <option value="0">Notification</option>
                    <option value="1">Homework</option>
                </select>

                <input type="hidden" name="option-no" value="">
                <div id="option-container">
                    <div class="cell-type-option" id="cell-type-option-0">
                        <label for="notification-note">Note</label>
                        <textarea type="text" name="notification-note" id="notification-note" row="3" cols="35">
                        </textarea>
                    </div>
                    
                    <div class="cell-type-option" id="cell-type-option-1">
                        <label for="homework-expireddate">Expiration DateTime(*)</label>
                        <input type="datetime-local" name="homework-expireddate" id="homework-expireddate" required>
                    </div>
                </div>            

                <button id="create-cell-button" class="button">Create</button>
                <button type="button" id="close-form-button" class="button">Close</button>
            </form>
        </div>
    </div>
    
  
    
    <input type="hidden" id="class-id" name="class-id" value="<?php echo $_REQUEST['class_id']?>">
    <script type="module" src="/elearning/class/class.js"></script>
    <script type="module" src="/elearning/class/form.js"></script>
</body>
</html>

<?php
    function isEnrolled() {
        include __DIR__ . '/../utils/config.php';
        
        $class_id = $_REQUEST['class_id'];
        $student_id = $_COOKIE['username'];
        $is_join = null;

        $conn = @new mysqli($servername, $username, $password, $database) or die($conn->connect_error);
        $conn->set_charset($charset);
        
        $stmt = $conn->prepare('SELECT count(*) FROM enrollment WHERE class_id = ? AND student_id = ?');
        $stmt->bind_param('ss', $class_id, $student_id);
        $stmt->bind_result($row_count);
        $stmt->execute();
        while ($stmt->fetch()) {
            if ($row_count === 0) {
                $is_join = false;
            } else if ($row_count === 1) {
                $is_join = true;
            }
        }

        $stmt->close();
        $conn->close();

        return $is_join;
    }

    function isBelong() {
        include __DIR__ . '/../utils/config.php';
        
        $class_id = $_REQUEST['class_id'];
        $instructor_id = $_COOKIE['username'];
        $is_belong = null;

        $conn = @new mysqli($servername, $username, $password, $database) or die($conn->connect_error);
        $conn->set_charset($charset);
        
        $stmt = $conn->prepare('SELECT count(*) FROM class WHERE class_id = ? AND instructor_id = ?');
        $stmt->bind_param('ss', $class_id, $instructor_id);
        $stmt->bind_result($row_count);
        $stmt->execute();
        while ($stmt->fetch()) {
            if ($row_count === 0) {
                $is_belong = false;
            } else if ($row_count === 1) {
                $is_belong = true;
            }
        }

        $stmt->close();
        $conn->close();

        return $is_belong;
    }