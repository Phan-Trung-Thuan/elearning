<?php
    session_start();
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Class</title>
</head>
<body>
    <?php
        if (!is_enrolled()) {
            $redirect_url = "/elearning/homepage/home.php";
            header("Location: $redirect_url");
        }
        
        include __DIR__ . '/../topnav/topnav.html';
                        
    ?>
    <input type="hidden" id="class_id" name="<?php echo $_REQUEST['class_id']?>">
    <script src="/elearning/class/class.js"></script>
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