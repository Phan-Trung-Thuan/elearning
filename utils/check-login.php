<?php
    function check_login($login_username, $login_password) {
        include __DIR__ . "/config.php";
        
        $conn = @new mysqli($servername, $username, $password, $database);
        //check connection
        if ($conn->connect_error) {
            die("Connection failed: " . $conn->connect_error);
        }
        
        # Check student login
        $stmt = $conn->prepare("SELECT student_password FROM student WHERE student_id = ?");
        $stmt->bind_param('s', $login_username);
        $stmt->execute();

        $data = array();

        $result = $stmt->get_result();
        if ($result->num_rows == 1) {
            $row = $result->fetch_assoc();
            $hash_password = $row['student_password'];
            $verify = password_verify($login_password, $hash_password);
            if ($verify) {
                # STUDENT LOGIN SUCCESSFULLY
                $data['login_status'] = "SUCCESS";
            } else {
                $data['login_status'] = "FAIL";
            }           
        }
        else {
            # Check instructor login
            $stmt = $conn->prepare("SELECT instructor_password FROM instructor WHERE instructor_id = ?");
            $stmt->bind_param('s', $login_username);
    
            $stmt->execute();

            $result = $stmt->get_result();    
            if ($result->num_rows == 1) {
                $row = $result->fetch_assoc();
                $hash_password = $row['instructor_password'];
                $verify = password_verify($login_password, $hash_password);
                if ($verify) {
                    # INSTRUCTOR LOGIN SUCCESSFULLY
                    $data['login_status'] = "SUCCESS";
                }
                else {
                    $data['login_status'] = "FAIL";
                }                
            }
            else {
                # LOGIN FAILED
                $data['login_status'] = "FAIL";
            }
        }
        $conn->close();
        return $data['login_status'];
    }
?>