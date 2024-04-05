<?php
    /* -----------------------------FUNCTIONS ------------------------- */

    //global variables
    $record_per_page = 5;

    function debug_to_console($data) {
        $output = $data;
        if (is_array($output))
            $output = implode(',', $output);
    
        echo "<script>console.log('Debug Objects: " . $output . "' );</script>";
    }

    //For pagination
    function compute_paging($search_kw) {        
        global $record_per_page;
        require __DIR__ . "/config.php";

        $conn = @new mysqli($servername, $username, $password, $database) or die 
        ('connection failed: ' . $conn->connect_error);
        mysqli_set_charset($conn,"utf8mb4");        

        $query = "SELECT count(*) FROM class WHERE class_name LIKE '%$search_kw%'";
        $result = $conn->query($query);
        $row = $result->fetch_row();
        $p_total = ceil($row[0]/$record_per_page);
        $page = (isset($_REQUEST["page"])) ? $_REQUEST["page"] : 1;
        $p_start = ($page-1)*$record_per_page;
        $p_next = ($page > 1) ? $page-1: 0;
        $p_prev = ($page < $p_total) ? $page+1 : 0;

        $conn->close();
        return array("p_total" => $p_total, "p_no" => $page, "p_start" => $p_start, "p_next" => $p_next, "p_prev" => $p_prev, "total" => $row[0]);
    }


    //Search class title by keywords
    function class_title_search_by($keyword) {
        global $record_per_page;
        require __DIR__ . "/config.php";

        $conn = @new mysqli($servername, $username, $password, $database) or die 
        ('connection failed: ' . $conn->connect_error);        
        mysqli_set_charset($conn,"utf8mb4");

        $search_kw = str_replace(" ", "%' OR class_name LIKE '%", trim($keyword));
        $paging = compute_paging($search_kw);
        $test = $paging['p_start'];
        $query = "SELECT class_id, class_name FROM class where class_name LIKE '%$search_kw%' LIMIT ". $paging['p_start'] . ", $record_per_page";
        $result = $conn->query($query);

        $class_list = array();
        if ($result && $result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                array_push($class_list, $row);
            }
        } else {
            //do something

            $conn->close();
            return null;
        }

        $conn->close();
        return $class_list;
    }