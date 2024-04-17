<?php
    include __DIR__ . "/../utils/config.php";
    $conn = @new mysqli($servername, $username, $password, $database) or die ('connection failed: ' . $conn->connect_error);   
    mysqli_set_charset($conn,"utf8mb4");
    $stmt = $conn->prepare("SELECT password from TEMP where student_id = ?");
    $s_id = "B2111001";
    $stmt->bind_param("s", $s_id);
    $stmt->execute();
    $result = $stmt->get_result();
    while ($row = $result->fetch_assoc()) {
        $s_hash_password = $row['password'];
        $verify = password_verify("pass001", $s_hash_password);
        if ($verify) {
            echo "SUCCESS";
        } else {
            echo "FAIL";
        }
    }
