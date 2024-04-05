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
        include __DIR__ . '/../utils/functions.php';
        
        $search_kw = isset($_REQUEST['class-title-keyword']) ? $_REQUEST['class-title-keyword'] : null;
        $class_list = array();
        if ($search_kw != null) {
            // debug_to_console($search_kw);
            $class_list = class_title_search_by($search_kw);
        }

        
    ?>

    <div id='class-cell'>
        
    </div>
</body>
</html>
