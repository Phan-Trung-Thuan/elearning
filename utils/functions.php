<?php
    session_start();
    date_default_timezone_set("Asia/Ho_Chi_Minh");
    /* -----------------------------FUNCTIONS ------------------------- */  
    function changeDateTimeFormat($datetime, $format) {
        return date($format, strtotime($datetime));
    }

    function remove_dir($dir) {
        if (is_dir($dir)) {
          $objects = scandir($dir);
          foreach ($objects as $object) {
            if ($object != "." && $object != "..") {
              if (filetype($dir."/".$object) == "dir") 
                 remove_dir($dir."/".$object); 
              else unlink   ($dir."/".$object);
            }
          }
          reset($objects);
          rmdir($dir);
        }
    }

    function getHWProgress($cell_id) {
        //Check cell type first
        $cell_data = getCellData($cell_id);        
        if ($cell_data['cell_type'] !== 'HOMEWORK') {
            return "Invalid cell type when trying to get homework progress";
        }

        $class_id = $cell_data['class_id'];
        $class_data = getClassData($class_id);
        // foreach ($class_data['enrollment'] as $student) {
            
        // }
    }

    /**
     * Get class info along with instructor info and students info
     * JSON format
     * {
     *      class: class_info
     *      enrollment: Array of students info
     *      instructor: ins_info     
     * }
     */
    function getClassData($class_id) {
        include __DIR__ . "/../utils/config.php";

        $conn = @new mysqli($servername, $username, $password, $database) or die 
        ('connection failed: ' . $conn->connect_error);   
        mysqli_set_charset($conn,"utf8mb4");

        $stmt = $conn->prepare("SELECT instructor_id, class_name FROM class WHERE class_id = ?");
        $stmt->bind_param("s", $class_id);
        $stmt->execute();
        $result = $stmt->get_result();
        
        $data = array();
        $instructor_id = null;
        while ($row = $result->fetch_assoc()) {
            //Only get key and value specified in array_flip
            $data['class'] = array_intersect_key(
                $row,
                array_flip(['class_name'])
            );

            $instructor_id = $row['instructor_id'];
        }        
        $stmt->close();

        $stmt_2 = $conn->prepare("SELECT instructor_name, instructor_dateofbirth FROM instructor WHERE instructor_id = ?");
        $stmt_2->bind_param("s", $instructor_id);
        $stmt_2->execute();
        $result_2 = $stmt_2->get_result();

        while ($row = $result_2->fetch_assoc()) {
            $data['instructor'] = $row;
        }
        $stmt_2->close();

        $stmt_3 = $conn->prepare("SELECT S.student_id, student_name, student_dateofbirth FROM student S INNER JOIN enrollment E ON S.student_id = E.student_id WHERE class_id = ?");
        $stmt_3->bind_param("s", $class_id);
        $stmt_3->execute();
        $result_3 = $stmt_3->get_result();

        $data['enrollment'] = array();
        while ($row = $result_3->fetch_assoc()) {
            array_push($data['enrollment'], $row);
        }
        $stmt_3->close();

        $conn->close();
        return $data;
    }

    function deleteClass($class_id) {
        //Clean up all files and cells
        $cells = getClassCell($class_id);
        $cell_ids = array_map( function($cell) { return $cell['cell_id']; }, $cells ); 
        foreach ( $cell_ids as $cell_id ) {
            cancelUploadFile($cell_id);
            deleteCell($cell_id);
        }

        include __DIR__ . "/../utils/config.php";

        $conn = @new mysqli($servername, $username, $password, $database) or die 
        ('connection failed: ' . $conn->connect_error);   
        mysqli_set_charset($conn,"utf8mb4");

        //Remove all students' enrollment
        $stmt_1 = $conn->prepare("DELETE FROM enrollment WHERE class_id = ?");
        $stmt_1->bind_param("s", $class_id);
        $stmt_1->execute();

        //Remove class
        $stmt_2 = $conn->prepare("DELETE FROM class WHERE class_id = ?");
        $stmt_2->bind_param("s", $class_id);
        $stmt_2->execute();

        $stmt_2->close();
        $conn->close();
        
        $data = array();
        $data['err_code'] = 0;
        return $data;
    }

    function updateClassName($class_id, $new_class_name) {
        include __DIR__ . "/../utils/config.php";

        $conn = @new mysqli($servername, $username, $password, $database) or die 
        ('connection failed: ' . $conn->connect_error);   
        mysqli_set_charset($conn,"utf8mb4");

        $stmt = $conn->prepare("UPDATE class SET class_name = ? WHERE class_id = ?");
        $stmt->bind_param("ss", $new_class_name, $class_id);
        $stmt->execute();

        $stmt->close();
        $conn->close();

        $data = array();
        $data["err_code"] = 0;
        return $data;
    }

    function createClass($class_name, $instructor_id) {
        include __DIR__ . "/../utils/config.php";

        $conn = @new mysqli($servername, $username, $password, $database) or die 
        ('connection failed: ' . $conn->connect_error);   
        mysqli_set_charset($conn,"utf8mb4");

        $new_id = "";
        $sql = "SELECT MAX(class_id) FROM class";
        $result = $conn->query($sql);
        if ($result->num_rows > 0) {
            $row = $result->fetch_row();
            $curr_id = $row[0];
            $new_id = ($curr_id != null) ? (string)((int)$row[0] + 1) : "10001";
        }

        $stmt = $conn->prepare("INSERT INTO class VALUES(?, ?, ?)");
        $stmt->bind_param("sss", $new_id, $instructor_id, $class_name);
        $stmt->execute();

        $stmt->close();
        $conn->close();

        return array("class_id" => $new_id);
    }

    function getInstructorClass($instructor_id) {
        include __DIR__ . "/../utils/config.php";

        $conn = @new mysqli($servername, $username, $password, $database) or die 
        ('connection failed: ' . $conn->connect_error);   
        mysqli_set_charset($conn,"utf8mb4");

        $stmt = $conn->prepare("SELECT class_id, class_name FROM class WHERE instructor_id = ?");
        $stmt->bind_param("s", $instructor_id);
        $stmt->execute();
        $result = $stmt->get_result();
        $data = array();
        while ($row = $result->fetch_assoc()) { 
            $class_info = array("class_id" => $row["class_id"], "class_name" => $row["class_name"]);
            array_push($data, $class_info);
        }

        $stmt->close();
        $conn->close();
        
        return $data;
    }

    function getClassName($class_id) {
        include __DIR__ . "/config.php";
        
        $conn = @new mysqli($servername, $username, $password, $database) or die($conn->connect_error);
        $conn->set_charset($charset);
        
        $stmt = $conn->prepare('SELECT CLASS_NAME FROM class WHERE class_id = ?');
        $stmt->bind_param('s', $class_id);
        $stmt->execute();
        $result = $stmt->get_result();
        $row = $result->fetch_assoc();

        $conn->close();
        return $row['CLASS_NAME'];
    }

    function leaveClass($student_id, $class_id) {
        include __DIR__ . "/../utils/config.php";

        $conn = @new mysqli($servername, $username, $password, $database) or die 
        ('connection failed: ' . $conn->connect_error);   
        mysqli_set_charset($conn,"utf8mb4");

        $stmt = $conn->prepare("DELETE FROM enrollment WHERE class_id = ? AND student_id = ?");
        $stmt->bind_param("ss", $class_id, $student_id);
        $stmt->execute();

        $stmt->close();
        $conn->close();

        return array("err_code" => 0);
    }

    function deleteCell($cell_id) {
        //Clean up file of that cell
        cancelUploadFile($cell_id);
        
        include __DIR__ . "/../utils/config.php";  
        
        $conn = @new mysqli($servername, $username, $password, $database) or die 
        ('connection failed: ' . $conn->connect_error);   
        mysqli_set_charset($conn,"utf8mb4");

        $cell_data = getCellData($cell_id);
        $cell_type = $cell_data['cell_type'];
        
        $data = null;
        
        if ($cell_type === 'NOTIFICATION') {               
            //Delete notification and its cell
            $stmt_1 = $conn->prepare("DELETE FROM notification WHERE cell_id = ?");
            $stmt_1->bind_param("s", $cell_id);
            $stmt_1->execute();
            $stmt_1->close(); 
            
            $stmt_2 = $conn->prepare("DELETE FROM cell WHERE cell_id = ?");
            $stmt_2->bind_param("s", $cell_id);
            $stmt_2->execute();
            $stmt_2->close();
            $data['cell_id'] = $cell_id;
        } else if ($cell_type === 'HOMEWORK') {
            $dir_path = __DIR__ . "/../files/homework/" . $cell_id . "/";
            remove_dir($dir_path);
            $stmt_1 = $conn->prepare("DELETE FROM homework WHERE cell_id = ?");
            $stmt_1->bind_param("s", $cell_id);
            $stmt_1->execute(); 
            $stmt_1->close();
            $stmt_2 = $conn->prepare("DELETE FROM cell WHERE cell_id = ?");
            $stmt_2->bind_param("s", $cell_id);
            $stmt_2->execute();
            $stmt_2->close();
            $data['cell_id'] = $cell_id;
        } else {                
            $data['err_code'] = 1;
        }        
        
        $conn->close();
        return $data;
    }

    function createCell($input_data) {
        include __DIR__ . "/../utils/config.php";  
        
        $conn = @new mysqli($servername, $username, $password, $database) or die 
        ('connection failed: ' . $conn->connect_error);   
        mysqli_set_charset($conn,"utf8mb4");

        $new_id = "";
        $sql = "SELECT MAX(cell_id) FROM cell";
        $result = $conn->query($sql);
        if ($result->num_rows > 0) {
            $row = $result->fetch_row();
            $curr_id = $row[0];
            $new_id = ($curr_id != null) ? (string)((int)$row[0] + 1) : "100001";
        }

        $create_date = date("Y-m-d H:i:s");

        $stmt_cell = $conn->prepare("INSERT INTO cell VALUES(?, ?, ?, ?, ?)");
        $stmt_cell->bind_param("sssss", $new_id, $input_data['class-id'], $input_data['cell-title'], $input_data['cell-description'], $create_date);
        $stmt_cell->execute();
        $stmt_cell->close();
        
        switch ($input_data['cell-type']) {
            case 0:
                $stmt_insert = $conn->prepare("INSERT INTO notification VALUES(?, ?)");
                $stmt_insert->bind_param("ss", $new_id, $input_data['notification-note']);
                $stmt_insert->execute();
                $stmt_insert->close();
                break;
            case 1:
                $stmt_insert = $conn->prepare("INSERT INTO homework VALUES(?, ?)");
                $stmt_insert->bind_param("ss", $new_id, $input_data['homework-expireddate']);
                $stmt_insert->execute();
                $stmt_insert->close();
                break;
        }
        
        return array('cell_id' => $new_id);
    }

    function cancelUploadFile($cell_id, $file_type = null, $username = null, $login_type = null) {
        $dir_path = null;
        $data = array();

        $hw_dir_path = __DIR__ . "/../files/homework/" . $cell_id . "/" . ($username ? $username . "/" : "");
        $doc_dir_path = __DIR__ . "/../files/document/" . $cell_id . "/";

        $all_paths = array($hw_dir_path, $doc_dir_path);

        //If not provide file type, delete all possible file types of a cell
        if ($file_type == null) {
            foreach ($all_paths as $path) {
                $dir_path = $path;
                if (is_dir($dir_path)) {
                    remove_dir($dir_path);
                } 
            }
        } else if (strtoupper($file_type) === "HOMEWORK") {
            $dir_path = $hw_dir_path;
            if (is_dir($dir_path)) {
                remove_dir($dir_path);
            } 
        } else if (strtoupper($file_type) === "DOCUMENT") {
            $dir_path = $doc_dir_path;
            if (is_dir($dir_path)) {
                remove_dir($dir_path);
            } 
        }

        // $data["error_code"] = 0;
        return $data;
    }

    function getFile($username, $login_type, $cell_id, $file_type) {
        $dir_path = null;
        if (strtoupper($file_type) === "HOMEWORK") {
            $dir_path = __DIR__ . "/../files/". $file_type . "/" . $cell_id . "/" . $username . "/";
        } else if (strtoupper($file_type) === "DOCUMENT") {
            $dir_path = __DIR__ . "/../files/". $file_type . "/" . $cell_id . "/";
        }      
        
        //If directory does not exist or is empty
        if (!is_dir($dir_path) or !(new FilesystemIterator($dir_path))->valid()) {
            return null;
        } else {
            $data = array();

            $data["dir"] = "/elearning/files/homework/". $cell_id . "/" . $username . "/";
            $data["length"] = 0;

            $files = scandir($dir_path);    
            $files_length = count($files);
            for ($i = 2; $i < $files_length; $i++) {               
                $tmp = explode(".", $files[$i]);
                $file_name = $tmp[0];
                $file_extension = $tmp[1];
                
                $data[$i-2] = array('file_name' => $file_name, 'file_extension' => $file_extension);
                $data["length"]++;
            }
            return $data;
        }
    }

    function getEnrollClass($student_id=null) {
        include __DIR__ . "/../utils/config.php";  
        
        $conn = @new mysqli($servername, $username, $password, $database) or die 
        ('connection failed: ' . $conn->connect_error);   
        mysqli_set_charset($conn,"utf8mb4");
        
        $filter = "";
        if ($student_id != null) {
            $filter = "inner join enrollment on class.class_id = enrollment.class_id where student_id = '$student_id'";
        }

        $sql = "SELECT class.class_id, class_name FROM class" . " " . $filter;
        $result = $conn->query($sql);   
        $data = array();    
        
        while ($row = $result->fetch_assoc()) { 
            $class_info = array("class_id" => $row["class_id"], "class_name" => $row["class_name"]);

            array_push($data, $class_info);
        }
        
        $conn->close();
        return $data;
    }

    function joinClass($student_id, $class_id) {
        include __DIR__ . "/config.php";
        
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
    }

    function checkLogin($login_username, $login_password) {
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
                $conn->close();
                return 'STUDENT';
            }
        }

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
                $conn->close();
                return 'INSTRUCTOR';
            }    
        }
        
        $conn->close();
        return 'FAIL';
    }

    function login($login_username, $login_password) {
        $result = checkLogin($login_username, $login_password);

        $data = array();
        if ($result == 'STUDENT') {
            # STUDENT LOGIN SUCCESSFULLY
            setcookie("username", $login_username, time() + 60 * 60 * 24 * 5, '/'); # 5 days
            setcookie("password", $login_password, time() + 60 * 60 * 24 * 5, '/');
            setcookie("type", "STUDENT", time() + 60 * 60 * 24 * 5, '/');
            // echo "STUDENT LOGIN SUCCESSFULLY";
            $data['login_status'] = "SUCCESS";
            $data['login_type'] = "STUDENT";
        }
        else if ($result == 'INSTRUCTOR'){
            # INSTRUCTOR LOGIN SUCCESSFULLY
            setcookie("username", $login_username, time() + 60 * 60 * 24 * 5, '/'); # 5 days
            setcookie("password", $login_password, time() + 60 * 60 * 24 * 5, '/');
            setcookie("type", "INSTRUCTOR", time() + 60 * 60 * 24 * 5, '/');
            // echo "INSTRUCTOR LOGIN SUCCESSFULLY";

            $data['login_status'] = "SUCCESS";
            $data['login_type'] = "INSTRUCTOR";
        }
        else {
            # LOGIN FAILED
            // echo "LOGIN FAILED";

            $data['login_status'] = "FAIL";
        }
        return $data;
    }
    
    function getCellData($cell_id) {
        include __DIR__ . "/config.php";
        
        $conn = @new mysqli($servername, $username, $password, $database) or die($conn->connect_error);
        $conn->set_charset($charset);

        $stmt = $conn->prepare("SELECT C.cell_id, class_id, cell_title, cell_description, cell_createddate, notification_note, homework_expirationdate FROM CELL C LEFT JOIN NOTIFICATION N on C.cell_id = N.cell_id LEFT JOIN HOMEWORK H on C.cell_id = H.cell_id WHERE C.cell_id = ?");
        $stmt->bind_param("s", $cell_id);
        $stmt->execute();
        $result = $stmt->get_result();

        $data = null;
        if ($result->num_rows == 1) {
            $row = $result->fetch_assoc();
            if ($row['homework_expirationdate'] != null) {
                $row['homework_expirationdate'] = changeDateTimeFormat($row['homework_expirationdate'], "d-m-Y H:i:s");
            }

            if ($row['notification_note'] !== null) {
                $row['cell_type'] = "NOTIFICATION";
            } else if ($row['homework_expirationdate'] !== null) {
                $row['cell_type'] = "HOMEWORK";
            }           
            foreach ($row as $key => $value) {
                if ($value) {
                    $row[$key] = nl2br($row[$key]);
                }
            }
            $data = $row;
        }

        $stmt->close();
        $conn->close();

        return $data;
    }

    function getClassCell($class_id) {
        include __DIR__ . "/config.php";
        
        $conn = @new mysqli($servername, $username, $password, $database) or die($conn->connect_error);
        $conn->set_charset($charset);
        
        $stmt = $conn->prepare("SELECT C.cell_id as cell_id FROM CELL C LEFT JOIN NOTIFICATION N on C.cell_id = N.cell_id LEFT JOIN HOMEWORK H on C.cell_id = H.cell_id WHERE class_id = ? ORDER BY cell_createddate");       

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

    //For pagination
    function computePaging($search_kw, $record_ppage, $page) {        
        require __DIR__ . "/../utils/config.php";

        $record_per_page = $record_ppage;

        $conn = @new mysqli($servername, $username, $password, $database) or die 
        ('connection failed: ' . $conn->connect_error);
        $conn->set_charset($charset);
        // mysqli_set_charset($conn,"utf8mb4");        

        $query = "SELECT count(*) FROM class WHERE class_name LIKE '%$search_kw%'";
        $result = $conn->query($query);
        $row = $result->fetch_row(); 
        $p_total = ceil($row[0]/$record_per_page);
        $p_start = ($page-1)*$record_per_page;
        $p_prev = ($page > 1) ? $page-1: 0;
        $p_next = ($page < $p_total) ? $page+1 : 0;

        $conn->close();
        return array("p_total" => $p_total, "p_no" => $page, "p_start" => $p_start, "p_next" => $p_next, "p_prev" => $p_prev, "total" => $row[0]);
    }

    //Search class title by keywords
    function classSearchBy($keyword, $record_ppage, $page) {        
        require __DIR__ . "/../utils/config.php";
        $record_per_page = $record_ppage;

        $conn = @new mysqli($servername, $username, $password, $database) or die 
        ('connection failed: ' . $conn->connect_error);        
        mysqli_set_charset($conn,"utf8mb4");

        $search_kw = str_replace(" ", "%' OR class_name LIKE '%", trim($keyword));
        $paging = computePaging($search_kw, $record_ppage, $page);
        $test = $paging['p_start'];
        $query = "SELECT class_id, class_name, instructor_name FROM class C INNER JOIN instructor I on C.instructor_id = I.instructor_id where class_name LIKE '%$search_kw%' LIMIT ". $paging['p_start'] . ", $record_per_page";
        
        $result = $conn->query($query);

        $class_list = array();
        if ($result && $result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                array_push($class_list, $row);
            }
        } else {
            //do something
            $conn->close();
            return;
        }

        $conn->close();
        return array("paging" => $paging, "raw_data" => $class_list);
    }

    function uploadFile($username, $login_type, $cell_id, $file_type) {        
        $dir_path = null;
        if (strtoupper($file_type) === "HOMEWORK") {
            $dir_path = __DIR__ . "/../files/". $file_type . "/" . $cell_id . "/" . $username . "/";
        } else if (strtoupper($file_type) === "DOCUMENT") {
            $dir_path = __DIR__ . "/../files/". $file_type . "/" . $cell_id . "/";
        }

        if (!is_dir($dir_path)) {
            mkdir($dir_path, 0777, true);
        }        

        $num_files = count($_FILES["file"]["name"]);

        $err_list = array();
        for ($i = 0; $i < $num_files; $i++) {
            $file_path = $dir_path . $_FILES["file"]["name"][$i];
            if ($_FILES["file"]["error"][$i] == UPLOAD_ERR_OK) {

                if (file_exists($file_path)) {
                    unlink($file_path);
                }
                move_uploaded_file($_FILES["file"]["tmp_name"][$i], $file_path);            
            } else {
                $err_list[$_FILES["file"]["name"][$i]] = $_FILES["file"]["error"][$i];
            }
        }

        return $err_list;
    }
    


    