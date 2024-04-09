<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search</title>
</head>

<body>
    <?php
        include __DIR__ . '/../topnav/topnav.html';
    ?>    

    <?php
        $record_ppage = 3;
        
        $search_kw = isset($_REQUEST['class-title-keyword']) ? $_REQUEST['class-title-keyword'] : null;

        $class_list = array();
        if ($search_kw != null) {
            $paging = array();            
            $class_list = class_title_search_by($search_kw, $record_ppage, $paging);            
            
            if ($class_list != null) {    
                $seperator = "$$$"; //seperator between html and css/js in class-cell-template.html
                $content = "";
                foreach ($class_list as $class) {
                    $template_data = array(
                        "class_id" => $class['class_id'],
                        "class_name" => $class['class_name'],
                        "instructor_name" => $class['instructor_name'] 
                    );
                    
                    $template_file_path = __DIR__ . "/class-cell-template.html";
                    $template_body = file_get_contents($template_file_path);
                    foreach ($template_data as $key => $value) {
                        $template_body = str_replace("[\$$key]", $value, $template_body);                            
                    }
                    $content = $content . explode($seperator, $template_body)[0];   
                }
                //Add css + js for class-cell
                $content = $content . explode($seperator, $template_body)[1];

                //Add class-cell to search
                echo $content;                                                 
                          
            }

            //Navigation
            $self_file_path = "/elearning/search/search.php";
            $keywords = $search_kw;
            $keywords = str_replace(" ", "+", $keywords);   

            if ($paging['p_total'] != 0) {
                echo "Page $paging[p_no]/$paging[p_total]&nbsp&nbsp&nbsp";

                if ($paging['p_prev'] > 0) {
                    echo "<a href=$self_file_path?class-title-keyword=$keywords&page=$paging[p_prev]>Previous</a>&nbsp&nbsp&nbsp";
                }

                if ($paging['p_next'] > 0) {
                    echo "<a href=$self_file_path?class-title-keyword=$keywords&page=$paging[p_next]>Next</a>&nbsp&nbsp&nbsp";
                }
            } else {
                echo "<h2>Not Found</h2>";
            }            
        }
    ?>

    <script src="/elearning/search/search.js"></script>
</body>
</html>

<?php
    //For pagination
    function compute_paging($search_kw, $record_ppage) {        
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
        $page = (isset($_REQUEST["page"])) ? $_REQUEST["page"] : 1;
        $p_start = ($page-1)*$record_per_page;
        $p_prev = ($page > 1) ? $page-1: 0;
        $p_next = ($page < $p_total) ? $page+1 : 0;

        $conn->close();
        return array("p_total" => $p_total, "p_no" => $page, "p_start" => $p_start, "p_next" => $p_next, "p_prev" => $p_prev, "total" => $row[0]);
    }


    //Search class title by keywords
    function class_title_search_by($keyword, $record_ppage, &$paging) {        
        require __DIR__ . "/../utils/config.php";
        $record_per_page = $record_ppage;

        $conn = @new mysqli($servername, $username, $password, $database) or die 
        ('connection failed: ' . $conn->connect_error);        
        mysqli_set_charset($conn,"utf8mb4");

        $search_kw = str_replace(" ", "%' OR class_name LIKE '%", trim($keyword));
        $paging = compute_paging($search_kw, $record_ppage);
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
