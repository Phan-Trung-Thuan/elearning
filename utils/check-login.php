<?php
    function check_login($login_username, $login_password) {
        include __DIR__ . "/config.php";
        
        $conn = @new mysqli($servername, $username, $password, $database);
        //check connection
        if ($conn->connect_error) {
            die("Connection failed: " . $conn->connect_error);
        }
        
        # Check student login
        $stmt = $conn->prepare("SELECT * FROM STUDENT WHERE STUDENT_ID = ? AND STUDENT_PASSWORD = ?");
        $stmt->bind_param('ss', $login_username, $login_password);
    
        $stmt->execute();
        $result = $stmt->get_result();
    
        $flag = false;
        if ($result->num_rows == 1) {
            # STUDENT LOGIN SUCCESSFULLY
            $flag = true;
        }
        else {
            # Check instructor login
            $stmt = $conn->prepare("SELECT * FROM INSTRUCTOR WHERE INSTRUCTOR_ID = ? AND INSTRUCTOR_PASSWORD = ?");
            $stmt->bind_param('ss', $login_username, $login_password);
    
            $stmt->execute();
            $result = $stmt->get_result();
    
            $conn->close();
            if ($result->num_rows == 1) {
                # INSTRUCTOR LOGIN SUCCESSFULLY
                $flag = true;
            }
            else {
                # LOGIN FAILED
                $flag = false;
            }
        }
        $conn->close();
        return $flag;
    }
?>