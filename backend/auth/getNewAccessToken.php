<?php
use Firebase\JWT\JWT;
use Firebase\JWT\Key;
require_once __DIR__ . "/generateAccessToken.php";

$headers = getallheaders();
if (!array_key_exists("Authorization", $headers) && !array_key_exists("authorization", $headers)) {
	http_response_code(401);
	exit();
}

$jwt = $headers["Authorization"] ?? $headers["authorization"];
$jwt = str_replace("Bearer ", "", $jwt);
$jwtSecretKey = file_get_contents(realpath(dirname(__FILE__) . "/.refresh-secret"));

try {
	$decodedRefreshToken = JWT::decode($jwt, new Key($jwtSecretKey, "HS256"));
	$correctUserInfo = getUserRefreshToken($decodedRefreshToken->sub);

	if ($jwt != $correctUserInfo["refreshToken"]) {
		http_response_code(401);
		exit();
	}

	$userData = [
		"id" => $decodedRefreshToken->sub,
		"nick" => $correctUserInfo["nick"],
		"email" => $correctUserInfo["email"],
	];

	exit(json_encode(generateAccessToken($userData)));
} catch (Exception $e) {
	http_response_code(403);
	exit(json_encode(["error" => $e->getMessage()], JSON_UNESCAPED_UNICODE));
}

function getUserRefreshToken($userId) {
	$conn = connect();
	$stmt = $conn->stmt_init();
	$sql = "SELECT * FROM `users` WHERE `id` = ?;";

    try {
        $stmt->prepare($sql);
        $stmt->bind_param("i", $userId);
        $stmt->execute();
        $result = $stmt->get_result();
        if ($result->num_rows == 0) return null;
    } catch (Exception $e) {
        http_response_code(500);
        exit(json_encode(["error" => $e->getMessage()]));
    } finally {
        $stmt->close();
        $conn->close();
    }

	return $result->fetch_assoc();
}
