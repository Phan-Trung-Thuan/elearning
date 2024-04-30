<?php
    include 'functions.php';

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
                $data = login($data['username'], $data['password']);
                echo json_encode($data);
                return;
            }

            if ($data['do'] === 'logout') {
                setcookie('username', '', time() - 100, '/');
                setcookie('password', '', time() - 100,'/');
                setcookie('type', '', time() - 100, '/');
                setcookie('username', '', time() - 100, '/');
                return;
            }

            if ($data['do'] === 'get_class_name') {
                $class_id = $data['class-id'];
                echo getClassName($class_id);
                return;
            }

            if ($data['do'] === 'join_class') {
                $class_id = $data['class-id'];
                $username = $_COOKIE['username'];                
                joinClass($username, $class_id);
                echo "SUCCESS";
                return;
            }

            if ($data['do'] === 'get_class_cell') {
                $class_id = $data['class-id'];
                $data = getClassCell($class_id);               
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

            if ($data['do'] === 'upload_file') {
                $username = $_COOKIE['username'];
                $login_type = $_COOKIE['type'];
                $cell_type = $data['cell-type'];
                $cell_id = $data['cell-id'];
                $err_file_list = uploadFile($username, $login_type, $cell_id, $cell_type);
                if (count( $err_file_list ) > 0) {
                    echo json_encode($err_file_list);
                } else {
                    echo json_encode(null);
                }
                return;
            }
            
            if ($data['do'] === 'get_enroll_class') {
                $username = $_COOKIE['username'];                
                $data = getEnrollClass($username);
                echo json_encode($data);
                return;
            }

            if ($data['do'] === 'get_instructor_class') {
                $instructor_id = $_COOKIE['username'];
                $data = getInstructorClass($instructor_id);
                echo json_encode($data);
                return;
            }

            if ($data['do'] === 'get_file') {
                $username = $_COOKIE['username'];
                $login_type = $_COOKIE['type'];
                $cell_id = $data['cell-id'];
                $cell_type = $data['cell-type'];
                $data = getFile($username, $login_type, $cell_id, $cell_type);
                echo json_encode($data);               
                return;
            }

            if ($data['do'] === 'cancel_upload_file') {
                $username = $_COOKIE['username'];
                $login_type = $_COOKIE['type'];
                $cell_id = $data['cell-id'];
                $cell_type = $data['cell-type'];
                $data = cancelUploadFile($cell_id, $cell_type, $username, $login_type);
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

            if ($data['do'] === 'leave_class') {
                $username = $_COOKIE['username'];
                $class_id = $data['class-id'];
                $data = leaveClass($username, $class_id);
                echo json_encode($data);
                return;
            }

            if ($data['do'] === 'delete_class') {
                $class_id = $data['class-id'];
                $data = deleteClass($class_id);
                echo json_encode($data);
                return;
            }
           
            if ($data['do'] === 'create_class') {
                $class_name = $data['class-name'];
                $instructor_id = $_COOKIE['username'];
                $data = createClass($class_name, $instructor_id);
                echo json_encode($data);
                return;
            }

            if ($data['do'] === 'update_class_name') {
                $class_id = $data['class-id'];
                $new_class_name = $data['new-class-name'];
                $data = updateClassName($class_id, $new_class_name);
                echo json_encode($data);
                return;
            }

            if ($data['do'] === 'get_hw_report') {
                $cell_id = $data['cell-id'];
                $data = getHWReport($cell_id);
                echo json_encode($data);
                return;
            }

        } else {
            echo "ERROR: Can't identify which function to execute at /elearning/utils/functions.php";
        }    
    }