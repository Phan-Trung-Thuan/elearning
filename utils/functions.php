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

            if (isset($data['do']) && $data['do'] === 'search_class') {
                $search_kw = $data['search_kw'];
                $record_ppage = $data['record_ppage'];
                $page = $data['page'];
                $paging = compute_paging($search_kw, $record_ppage, $page);
                $data = class_title_search_by($search_kw, $record_ppage, $page);
                echo json_encode(array('paging' => $paging, 'raw_data' => $data));             
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

    //For pagination
    function compute_paging($search_kw, $record_ppage, $page) {        
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
    function class_title_search_by($keyword, $record_ppage, $page) {        
        require __DIR__ . "/../utils/config.php";
        $record_per_page = $record_ppage;

        $conn = @new mysqli($servername, $username, $password, $database) or die 
        ('connection failed: ' . $conn->connect_error);        
        mysqli_set_charset($conn,"utf8mb4");

        $search_kw = str_replace(" ", "%' OR class_name LIKE '%", trim($keyword));
        $paging = compute_paging($search_kw, $record_ppage, $page);
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
        return $class_list;
    }

    


    