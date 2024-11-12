<?php
session_start();
use Firebase\JWT\JWT;
require_once "./generateAccessToken.php";

function getUserData($username) {
    $conn = connect();
    $stmt = $conn->stmt_init();
    $sql = "SELECT * FROM `user` WHERE (`email` = ? OR `nick` = ?);";

    try {
        $stmt->prepare($sql);
        $stmt->bind_param("ss", $username, $username);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows <= 0) {
            http_response_code(404); // Niepoprawny e-mail / nick lub hasło
            exit();
        }

        return $result->fetch_assoc();
    } catch (Exception $e) {
        http_response_code(500);
        exit();
    } finally {
        $stmt->close();
        $conn->close();
    }
}

function generateRefreshToken($userId){
    $refreshTokenPayload = [
        "sub" => $userId,
        "exp" => time() + 30 * 24 * 60 * 60, // 30 days expiration
    ];

    $jwtSecretKey = file_get_contents("./.refresh-secret");
    $refreshToken = JWT::encode($refreshTokenPayload, $jwtSecretKey, "HS256");
    saveRefreshToken($userId, $refreshToken);
    return $refreshToken;
}

function saveRefreshToken($userId, $refreshToken){
    $conn = connect();
    $stmt = $conn->stmt_init();
    $sql = "UPDATE `user` SET `refreshToken` = ? WHERE `id` = ?;";

    try {
        $stmt->prepare($sql);
        $stmt->bind_param("si", $refreshToken, $userId);
        $stmt->execute();
    } catch (Exception $e) {
        http_response_code(500);
        exit(json_encode(["error" => $e->getMessage(), "type" => "dbError"], JSON_UNESCAPED_UNICODE));
    } finally {
        $stmt->close();
        $conn->close();
    }
}

if (!isset($inputJson)) {
    http_response_code(400);
    exit();
}

$mail = $inputJson["mail"];
$userData = getUserData($mail);

$correctPasswordHash = $userData["password"];
$passwordCorrect = password_verify($inputJson["password"], $correctPasswordHash);

if (!$passwordCorrect) {
    http_response_code(404);
    exit(json_encode(["error" => "Niepoprawny adres e-mail lub hasło"], JSON_UNESCAPED_UNICODE));
}

// W przyszłości tutaj sprawdzać czy e-mail jest zweryfikowany

$at = generateAccessToken($userData);
$rt = generateRefreshToken($userData["id"]);
exit(json_encode(["accessToken" => $at, "refreshToken" => $rt]));