<?php

$credentials = verifyJWT();
$userId = $credentials["userId"];

$conn = connect();
$stmt = $conn->stmt_init();
$sql = "UPDATE `user` SET `refreshToken` = NULL WHERE `id` = ?";

try {
    $stmt->prepare($sql);
    $stmt->bind_param("i", $userId);
    $stmt->execute();
} catch (Exception $e) {
    $msg = json_encode(
        [
            "error" => $e->getMessage(),
            "errorCode" => $e->getCode(),
            "type" => "dbError",
        ],
        JSON_UNESCAPED_UNICODE
    );
    http_response_code(500);
    exit($msg);
}


http_response_code(200);