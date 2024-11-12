<?php
use Firebase\JWT\JWT;

function generateAccessToken($userData){
	$jwtSecretKey = file_get_contents(__DIR__ . "/.jwt-secret");
	$expirationTime = time() + 60 * 60; // 1 hour
	$payload = [
		"sub" => $userData["id"],
		"preferred_username" => $userData["nick"],
		"email" => $userData["email"],
		"exp" => $expirationTime,
	];

	$jwt = JWT::encode($payload, $jwtSecretKey, "HS256");
	return [
		"token" => $jwt,
		"expiration" => $expirationTime,
	];
}
