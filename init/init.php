<?php
    include __DIR__ . "/../utils/config.php";
    $conn = @new mysqli($servername, $user, $password, $database) or die ('connection failed: ' . $conn->connect_error);   
    mysqli_set_charset($conn,"utf8mb4");
    $stmt = $conn->prepare("INSERT INTO STUDENT values(?, ?, ?, ?)");
    $stmt->bind_param("ssss", $s_id, $s_name, $s_date_of_birth, $s_hash_password);
    
    //id|name|date|plain_password
    $student_data = array(
        "B2111001, Nguyen Van A, 2003-01-01, pass001",
        "B2111002, Tran Thi B, 2003-05-01, pass002",
        "B2111003, Phan Van C, 2003-11-01, pass003"
    );

    foreach ($student_data as $str) {
        $acc = explode(", ", $str);
        $s_id = $acc[0];
        $s_name = $acc[1];
        $s_date_of_birth = $acc[2];
        $s_hash_password = password_hash($acc[3], PASSWORD_DEFAULT);
        $stmt->execute();
    }

    $stmt->close();

    $stmt = $conn->prepare("INSERT INTO INSTRUCTOR values(?, ?, ?, ?)");
    $stmt->bind_param("ssss", $i_id, $i_name, $i_date_of_birth, $i_hash_password);
    
    $instructor_data = array(
        "GV001, Thai Ha X, 1986-01-01, pass001",
        "GV002, Huu Van Y, 1980-03-01, pass002",
        "GV003, Huynh Van Z', 1989-12-01, pass003"
    );

    foreach ($instructor_data as $str) {
        $acc = explode(", ", $str);
        $i_id = $acc[0];
        $i_name = $acc[1];
        $i_date_of_birth = $acc[2];
        $i_hash_password = password_hash($acc[3], PASSWORD_DEFAULT);
        $stmt->execute();
    }

    $conn->close();