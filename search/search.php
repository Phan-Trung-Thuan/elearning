<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search</title>
    <link rel="stylesheet" href="/elearning/style/search-style.css">
    <link rel="stylesheet" href="/elearning/style/warning-box-style.css">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.5.0/css/all.css"
        integrity="sha384-B4dIYHKNBt8Bc12p+WXckhzcICo0wtJAoU8YZTY5qE0Id1GSseTk6S+L3BlXeVIU" crossorigin="anonymous">
</head>

<body>
    <?php
        # Check login cookie
        if (!isset($_COOKIE["type"])) {
            header("Location: /elearning/login/index.php");
        }
        
        include __DIR__ . '/../topnav/topnav.html';
        include __DIR__ . '/../utils/warning-box.html';
    ?>

    <div id="main-container">
        <div id="search-container">
            <template id="class-cell-template">
                <div class="class-cell">
                    <span class="id">${class_id}</span>
                    <span class="class-name">${class_name}</span>
                    <div class="instructor-name">Instructor: <i class="fa-solid fa-user-graduate"></i><a
                            href="">${instructor_name}</a></div>
                    <form class="join-form" id="join-form-${class_id}" action="/elearning/utils/functions.php"
                        method="POST">
                        <input type="hidden" name="class-id" value="${class_id}">
                        <button class="join-button" classId="${class_id}">Join Class</button>
                    </form>
                </div>
            </template>
        </div>

        <div id="search-navigation">
            <template id="search-navigation-template">
                <div><div id="previous-button">
                    <a href="${self_file_path}?class-title-keyword=${search_kw}&page=${p_prev}&ppage=${ppage}">
                        <i class="fa-solid fa-chevron-left"></i> Prev
                    </a>
                </div>

                <div id="page-content">
                    Page ${p_no}/${p_total}
                </div>

                <div id="next-button">
                    <a href="${self_file_path}?class-title-keyword=${search_kw}&page=${p_next}&ppage=${ppage}">
                        Next <i class="fa-solid fa-chevron-right"></i>
                    </a>
                </div></div>
            </template>
        </div>
    </div>

    <input type="hidden" id="search-kw" name="search-kw" value="<?php echo $_REQUEST['class-title-keyword'] ?>">
    <input type="hidden" id="page" name="page" value="<?php echo isset($_REQUEST['page']) ? $_REQUEST['page'] : 1 ?>">
    <input type="hidden" id="ppage" name="ppage"
        value="<?php echo isset($_REQUEST['ppage']) ? $_REQUEST['ppage'] : 3 ?>">

    <script src="/elearning/search/search.js" type="module"></script>
</body>

</html>