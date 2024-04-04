<?php
    /* -----------------------------FUNCTIONS ------------------------- */

    //global variables
    $record_per_page = 5;

    //Get all classes that joined by a student
    //If not specify the student, get all classes instead.
    function get_class_by($student_id=null) {
        require "config.php";        
        $conn = @new mysqli($servername, $username, $password, $database) or die 
        ('connection failed: ' . $conn->connect_error);
        //check connection
        if ($conn->connect_error) {
            die("Connection failed : " . $conn->connect_error);
        }
        
        $filter = "";
        if ($student_id != null) {
            $filter = "inner join enrollment on class.class_id = enrollment.class_id where student_id = $student_id";
        }

        $sql = "SELECT class_id, class_name FROM class" . " " . $filter;
        $result = $conn->query($sql);
        $classroom_list = array();
        while ($row = $result->fetch_assoc()) {
            array_push($classroom_list, $row);                
        }

        $conn->close();
        return $classroom_list;           
    }

    //For pagination
    function compute_paging($search_kw) {        
        global $record_per_page;

        require "config.php";
        $conn = @new mysqli($servername, $username, $password, $database) or die 
        ('connection failed: ' . $conn->connect_error);        

        $query = "SELECT count(*) FROM class WHERE class_name LIKE '%$search_kw%'";
        $result = $conn->query($query);
        $row = $result->fetch_row();
        $p_total = ceil($row[0]/$record_per_page);
        $page = (isset($_REQUEST["page"])) ? $_REQUEST["page"] : 1;
        $start = ($page-1)*$record_per_page;
        $p_next = ($page > 1) ? $page-1: 0;
        $p_prev = ($page < $p_total) ? $page+1 : 0;

        $conn->close();
        return array("p_total" => $p_total, "p_no" => $page, "p_start" => $p_start, "p_next" => $p_next, "p_prev" => $p_prev, "total" => $row[0]);
    }


    //Search class title by keywords
    function class_title_search($keyword) {
        global $record_per_page;
        require "config.php";
        $conn = @new mysqli($servername, $username, $password, $database) or die 
        ('connection failed: ' . $conn->connect_error);
        $search_kw = str_replace(" ", "%' OR class_name LIKE %'", trim($keyword));

        $paging = compute_paging($search_kw);
        $test = $paging['p_start'];
        $query = "SELECT class_id, class_name FROM class where class_name LIKE '%search_kw%' LIMIT ". $paging['p_start'] . ", $record_per_page";
        $result = $conn->query($query);
        if ($result && $result->num_rows > 0) {
            $row = $result->fetch_assoc();
            echo "". $row["class_id"] ."-". $row["class_name"];
        } else {
            $conn->close();
            //do something
        }

        $conn->close();
    }