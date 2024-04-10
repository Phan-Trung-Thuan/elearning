<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search</title>
    <link rel="stylesheet" href="/elearning/style/search-style.css">
</head>

<body>
    <?php
        include __DIR__ . '/../topnav/topnav.html';
    ?>    
    
    <div id="search-container">
        <template id="class-cell-template">
            <div class="class-cell">
                <span class="id">${class_id}</span>
                <span class="class-name">${class_name}</span>
                <div class="instructor-name">Giảng viên: <a href="">${instructor_name}</a></div>
                <button class="join-button" classId="${class_id}">Join Class</button>
            </div>
        </template>
    </div>
    
    <div id="search-navigation">
        <template id="search-navigation-template">
            Page ${p_no}/${p_total}&nbsp&nbsp&nbsp
            <a href="${self_file_path}?class-title-keyword=${search_kw}&page=${p_prev}&ppage=${ppage}">Previous</a>&nbsp&nbsp&nbsp
            <a href="${self_file_path}?class-title-keyword=${search_kw}&page=${p_next}&ppage=${ppage}">Next</a>&nbsp&nbsp&nbsp
        </template>
    </div>
    
    <input type="hidden" id="search-kw" name="search-kw" value="<?php echo $_REQUEST['class-title-keyword']?>">
    <input type="hidden" id="page" name="page" value="<?php echo isset($_REQUEST['page']) ? $_REQUEST['page'] : 1 ?>">
    <input type="hidden" id="ppage" name="ppage" value="<?php echo isset($_REQUEST['ppage']) ? $_REQUEST['ppage'] : 3?>">
    
    <script src="/elearning/search/search.js" type="module"></script>
</body>
</html>