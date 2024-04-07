<?php
    /* -----------------------------FUNCTIONS ------------------------- */  
    session_start();   

    call();
    function call() {
        include __DIR__ . "/config.php";
        $data = json_decode(file_get_contents('php://input'), true);
        if (isset($data)) {
            if (isset($data['do']) && $data['do'] === 'join_class') {
                $class_id = $data['class_id'] or die("Class id not found when trying to join class!");
                $student_id = $_SESSION['username'];
                
                $conn = @new mysqli($servername, $username, $password, $database) or die($conn->connect_error);
                $conn->set_charset($charset);
                
                $stmt_check = $conn->prepare('SELECT count(*) FROM enrollment WHERE class_id = ? AND student_id = ?');
                $stmt_check->bind_param('ss', $class_id, $student_id);
                $stmt_check->bind_result($row_count);
                $stmt_check->execute();
                if ($stmt_check->fetch()) {
                    if ($row_count == 0) {
                        $stmt_check->close();
                        $stmt_insert = $conn->prepare('INSERT INTO enrollment values(?, ?)');
                        $stmt_insert->bind_param('ss', $class_id, $student_id);
                        $stmt_insert->execute();
                        $stmt_insert->close();
                    }
                }

                
                $conn->close();
            }
        }
    }


    