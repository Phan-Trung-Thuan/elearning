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

    call();
    function call() {
        include __DIR__ . "/config.php";

        if ($_SERVER['REQUEST_METHOD'] === 'GET') { //GET method
            $query_string = $_SERVER['QUERY_STRING'];
            parse_str($query_string, $data);
        } else { // POST method with body is JSON or FormData
            if (file_get_contents('php://input') != null) {
                $data = json_decode(file_get_contents('php://input'), true);
            } else if (isset($_REQUEST['form_params'])) {
                $data = json_decode($_REQUEST['form_params'], true); 

                foreach ($_REQUEST as $key => $value) {
                    $data[$key] = $_REQUEST[$key];
                }
            }
        }        
        
        if (isset($data) && isset($data['do'])) {
            if ($data['do'] === 'login') {
                login($data['username'], $data['password']);
            }

            if ($data['do'] === 'logout') {
                setcookie('type', '', time() - 100, '/');
            }

            if ($data['do'] === 'join_class') {
                $class_id = $data['class-id'];
                $student_id = $_SESSION['username'];                
                joinClass($student_id, $class_id);
                echo "SUCCESS";
                return;
            }

            if ($data['do'] === 'get_init_cell') {
                $class_id = $data['class-id'];
                $data = getInitCell($class_id);               
                echo json_encode($data);
                return;
            }

            if ($data['do'] === 'search_class') {
                $search_kw = $data['search-kw'];
                $record_ppage = $data['record-ppage'];
                $page = $data['page'];
                $data = classSearchBy($search_kw, $record_ppage, $page);
                // echo json_encode(array('paging' => $paging, 'raw_data' => $data));
                echo json_encode($data);             
                return;
            }

            if ($data['do'] === 'upload_homework') {
                $student_id = $_SESSION["username"];
                $err_file_list = uploadHomeworkFile($student_id);
                if (count( $err_file_list ) > 0) {
                    echo json_encode($err_file_list);
                } else {
                    echo json_encode(null);
                }
                return;
            }
            
            if ($data['do'] === 'get_enroll_class') {
                $student_id = $_SESSION['username'];
                $data = getEnrollClass($student_id);
                echo json_encode($data);
                return;
            }

            if ($data['do'] === 'get_homework') {
                $student_id = $_SESSION['username'];
                // $cell_id = $_REQUEST['cell-id'];
                $cell_id = $data["cell-id"];
                $data = getHomework($student_id, $cell_id);
                echo json_encode($data);               
                return;
            }

            if ($data['do'] === 'cancel_homework') {
                $student_id = $_SESSION['username'];
                $cell_id = $data['cell-id'];
                $data = cancelHomework($student_id, $cell_id);
                echo json_encode($data);
                return;
            }

            if ($data['do'] === 'create_cell') {
                $input_data = array(
                    'class-id'=> $data['class-id'],
                    'cell-title' => $data['cell-title'],
                    'cell-description'=> $data['cell-description'],
                    'cell-type' => $data['option-no'],
                );

                switch ($data['option-no']) {
                    case 0:
                        $input_data['notification-note'] = $data['notification-note'];
                        break;
                    case 1:
                        $input_data['homework-expireddate'] = $data['homework-expireddate'];
                        break;
                }

                $data = createCell($input_data);
                echo json_encode($data);
                return;
            }

            if ($data['do'] === 'get_cell_data') {
                $cell_id = $data['cell-id'];
                $data = getCellData($cell_id);
                echo json_encode($data);
                return;
            }

            if ($data['do'] === 'delete_cell') {
                $cell_id = $data['cell-id'];
                $data = deleteCell($cell_id);
                echo json_encode($data);
                return;
            }

        } else {
            echo "ERROR: Can't identify which function to execute at /elearning/utils/functions.php";
        }    
    }

    function deleteCell($cell_id) {
        include __DIR__ . "/../utils/config.php";  
        
        $conn = @new mysqli($servername, $username, $password, $database) or die 
        ('connection failed: ' . $conn->connect_error);   
        mysqli_set_charset($conn,"utf8mb4");

        $stmt = $conn->prepare("SELECT N.cell_id, H.cell_id FROM CELL C LEFT JOIN NOTIFICATION N on C.cell_id = N.cell_id LEFT JOIN HOMEWORK H on C.cell_id = H.cell_id WHERE C.cell_id = ?");
        $stmt->bind_param("s", $cell_id);
        $stmt->bind_result($is_notification, $is_homework);
        $stmt->execute();
        
        $data = null;
        if ($stmt->fetch()) {
            $stmt->close();
            if ($is_notification) {               
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
            } else if ($is_homework) {
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

    function cancelHomework($student_id, $cell_id) {
        $dir_path = __DIR__ . "/../files/homework/" . $cell_id . "/" . $student_id . "/";
        
        $data = array();
        //If directory does not exist
        if (!is_dir($dir_path)) {
            $data["error_code"] = 1;  //DIR DOES NOT EXIST
        } else {
            remove_dir($dir_path);
        }

        return $data;
    }

    function getHomework($student_id, $cell_id) {
        $dir_path = __DIR__ . "/../files/homework/" . $cell_id . "/" . $student_id . "/";
        
        //If directory does not exist or is empty
        if (!is_dir($dir_path) or !(new FilesystemIterator($dir_path))->valid()) {
            return null;
        } else {
            $data = array();

            $data["dir"] = "/elearning/files/homework/". $cell_id . "/" . $student_id . "/";
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

    function login($login_username, $login_password) {
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
    
        if ($result->num_rows == 1) {
            # STUDENT LOGIN SUCCESSFULLY
            setcookie("username", $login_username, time() + 60 * 60 * 24 * 5, '/'); # 5 days
            setcookie("password", $login_password, time() + 60 * 60 * 24 * 5, '/');
            setcookie("type", "STUDENT LOGIN", time() + 60 * 60 * 24 * 5, '/');
            echo "STUDENT LOGIN SUCCESSFULLY";
        }
        else {
            # Check instructor login
            $stmt = $conn->prepare("SELECT * FROM INSTRUCTOR WHERE INSTRUCTOR_ID = ? AND INSTRUCTOR_PASSWORD = ?");
            $stmt->bind_param('ss', $login_username, $login_password);
    
            $stmt->execute();
            $result = $stmt->get_result();
    
            if ($result->num_rows == 1) {
                # INSTRUCTOR LOGIN SUCCESSFULLY
                setcookie("username", $login_username, time() + 60 * 60 * 24 * 5, '/'); # 5 days
                setcookie("password", $login_password, time() + 60 * 60 * 24 * 5, '/');
                setcookie("type", "INSTRUCTOR LOGIN", time() + 60 * 60 * 24 * 5, '/');
                echo "INSTRUCTOR LOGIN SUCCESSFULLY";
            }
            else {
                # LOGIN FAILED
                echo "LOGIN FAILED";
            }
        }
        $conn->close();
    }
    
    function getCellData($cell_id) {
        include __DIR__ . "/config.php";
        
        $conn = @new mysqli($servername, $username, $password, $database) or die($conn->connect_error);
        $conn->set_charset($charset);

        $stmt = $conn->prepare("SELECT C.cell_id, cell_title, cell_description, cell_createddate, notification_note, homework_expirationdate FROM CELL C LEFT JOIN NOTIFICATION N on C.cell_id = N.cell_id LEFT JOIN HOMEWORK H on C.cell_id = H.cell_id WHERE C.cell_id = ?");
        $stmt->bind_param("s", $cell_id);
        $stmt->execute();
        $result = $stmt->get_result();

        $data = null;
        if ($result->num_rows == 1) {
            $row = $result->fetch_assoc();
            if ($row['homework_expirationdate'] != null) {
                $row['homework_expirationdate'] = changeDateTimeFormat($row['homework_expirationdate'], "d-m-Y H:i:s");
            } 
            $data = $row;
        }

        $stmt->close();
        $conn->close();

        return $data;
    }

    function getInitCell($class_id) {
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

    function uploadHomeworkFile($student_id) {
        $save_dir = __DIR__ . "/../files/homework/" . $_REQUEST["cell-id"] . "/" . $student_id . "/";

        if (!is_dir($save_dir)) {
            mkdir($save_dir, 0777, true);
        }        

        $num_files = count($_FILES["file"]["name"]);

        $err_list = array();
        for ($i = 0; $i < $num_files; $i++) {
            $file_path = $save_dir . $_FILES["file"]["name"][$i];
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
    


    