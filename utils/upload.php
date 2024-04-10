<?php
    session_start();

    $save_dir = __DIR__ . "/../files/homework/" . $_REQUEST["cell_id"] . "/" . $_SESSION["username"] . "/";

    if (!is_dir($save_dir)) {
        mkdir($save_dir, 0777, true);
    }

    $num_files = count($_FILES["file"]["name"]);

    $is_success_all = true;
    for ($i = 0; $i < $num_files; $i++) {
        $file_path = $save_dir . $_FILES["file"]["name"][$i];
        if ($_FILES["file"]["error"][$i] == UPLOAD_ERR_OK) {

            if (file_exists($file_path)) {
                unlink($file_path);
            }
            move_uploaded_file($_FILES["file"]["tmp_name"][$i], $file_path);            
        } else {
            $is_success_all = false;
            echo "Upload error: " . $_FILES["file"]["name"][$i] . "\n";
        }
    }

    if ($is_success_all) {
        echo "Upload files success!";
    }