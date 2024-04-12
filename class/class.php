<?php
    session_start();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Class</title>

    <link rel="stylesheet" href="/elearning/style/class-style.css">
</head>
<body>
    <?php
        if (!is_enrolled()) {
            $redirect_url = "/elearning/homepage/home.php";
            header("Location: $redirect_url");
        }
        
        include __DIR__ . '/../topnav/topnav.html';
                        
    ?>

    <div id="class-cell-container">
        <template id="notification-cell-template">
            <div class="notification-cell">
                <div class="notification-cell-title">${cell_title}</div>

                <div class="notification-cell-desc">${cell_description}</div>

                <div class="notification-cell-note">${notification_note}</div>
            </div>
        </template>

        <template id="homework-cell-template">
            <div class="homework-cell">
                <div class="homework-cell-title">${cell_title}</div>

                <div class="homework-cell-desc">${cell_description}</div>
                
                <form class="homework-input-form" id="homework-input-form-${cell_id}" method="POST" enctype="multipart/form-data" action="/elearning/utils/functions.php">
                    <input type="hidden" name="cell-id" value="${cell_id}">
                    <input type="file" name="file[]" class="homework-file-upload" multiple>                    
                    <button class="upload-button">Upload</button>                                                           
                </form>

                <form class="homework-output-form" id="homework-output-form-${cell_id}" method="POST" action="/elearning/utils/functions.php">
                    <input type="hidden" name="cell-id" value="${cell_id}">
                    <ul class="homework-list" id="homework-list-${cell_id}"></ul>
                    <button class="cancel-button">Cancel</button>
                </form>             
            
                <div class="homework-cell-expiration-date">${homework_expirationdate}</div>
            </div>
        </template>
    </div>
    
    <input type="hidden" id="class-id" name="class-id" value="<?php echo $_REQUEST['class_id']?>">
    <script src="/elearning/class/class.js" type="module"></script>
</body>
</html>

<?php
    function is_enrolled() {
        include __DIR__ . '/../utils/config.php';
        
        $class_id = $_REQUEST['class_id'];
        $student_id = $_SESSION['username'];
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