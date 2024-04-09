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
                
                $stmt = $conn->prepare('SELECT count(*) FROM enrollment WHERE class_id = ? AND student_id = ?');
                $stmt->bind_param('ss', $class_id, $student_id);
                $stmt->bind_result($row_count);
                $stmt->execute();
                if ($stmt->fetch()) {
                    if ($row_count === 0) {
                        $stmt->close();
                        $stmt_insert = $conn->prepare('INSERT INTO enrollment values(?, ?)');
                        $stmt_insert->bind_param('ss', $class_id, $student_id);
                        $stmt_insert->execute();
                        $stmt_insert->close();
                    }                    
                }                
                $conn->close();
                echo "SUCCESS";
                return;
            }

            if (isset($data['do']) && $data['do'] === 'get_init_cell') {
                $class_id = $data['class_id'];
                $notification_data = getNotificationCell($class_id);               
                echo json_encode($notification_data);
                return;
            }
            
        }       
        
        echo "ERROR";
    }

    function getNotificationCell($class_id) {
        include __DIR__ . "/config.php";
        
        $conn = @new mysqli($servername, $username, $password, $database) or die($conn->connect_error);
        $conn->set_charset($charset);
        
        $stmt = $conn->prepare('SELECT cell_title, cell_description, cell_createddate, notification_note FROM cell C INNER JOIN notification N on C.cell_id = N.cell_id WHERE class_id = ? ORDER BY cell_createddate');
        $stmt->bind_param('s', $class_id);
        $stmt->execute();

        $data = array();
        $result = $stmt->get_result();
        while ($row = $result->fetch_assoc()) {
            array_push($data, $row);
        }


        $stmt->close();
        $conn->close();

        return $data;
    }


    