<?php
/**
 * Tworzy użytkownika w bazie danych
 */
function createUser($mail, $username, $passwordHash){
	$conn = connect();
	$stmt = $conn->stmt_init();
	$sql = "INSERT INTO `user` (`email`, `nick`, `password`)  VALUES (?, ?, ?);";

    try {
        $stmt->prepare($sql);
        $stmt->bind_param("sss", $mail, $username, $passwordHash);
        $stmt->execute();

        return $stmt->insert_id;
    } catch (Exception $e) {
        if ($conn->errno === 1062) {
            $errors = [];
            if (str_contains($stmt->error, "nick")) {
                $errors[] = [
                    "error" => "Ta nazwa jest już zajęta",
                    "type" => "username",
                ];
            }

            if (str_contains($stmt->error, "email")) {
                $errors[] = [
                    "error" => "Użytkownik o tym adresie już istnieje",
                    "type" => "mail",
                ];
            }

            http_response_code(409);
            exit(json_encode(["errors" => $errors]));
        }

        http_response_code(500);
        exit(@$msg ?? "");
    } finally {
        $stmt->close();
        $conn->close();
    }
}

/**
 * Sprawdza czy e-mail i hasło spełniają wymagania
 */
function verify($credentials){
	$errors = [];

	function hasUppercase($string){
		return (bool) preg_match("/[A-Z]/", $string);
	}

    function hasLowercase($string){
		return (bool) preg_match("/[a-z]/", $string);
	}

    function hasNumber($string){
		return (bool) preg_match("/[0-9]/", $string);
	}

	if (!filter_var($credentials["mail"], FILTER_VALIDATE_EMAIL)) {
		array_push($errors, [
			"error" => "Nieprawidłowy adres E-mail",
			"errorEn" => "Invalid email address",
			"type" => "mail",
		]);
	}

	if (strlen($credentials["username"]) == 0) {
		array_push($errors, [
			"error" => "Wymyśl nazwę użytkownika",
			"type" => "username",
		]);
	}

	if (str_contains($credentials["username"], "@")) {
		array_push($errors, [
			"error" => "Nazwa nie może zawierać @",
			"type" => "username",
		]);
	}

	if (strlen($credentials["username"]) > 30) {
		array_push($errors, [
			"error" => "Za długa nazwa (max. 70 znaków)",
			"type" => "username",
		]);
	}

	if (strlen($credentials["password"]) == 0) {
		array_push($errors, [
			"error" => "Należy podać hasło",
			"type" => "password",
		]);
	}

	if (strlen($credentials["password"]) < 8) {
		array_push($errors, [
			"error" => "Hasło musi mieć co najmniej 8 znaków",
			"type" => "password",
		]);
	}

	if (!hasUppercase($credentials["password"])) {
		array_push($errors, [
			"error" => "Hasło musi zawierać wielką literę",
			"type" => "password",
		]);
	}

    if (!hasLowercase($credentials["password"])) {
		array_push($errors, [
			"error" => "Hasło musi zawierać małą literę",
			"type" => "password",
		]);
	}

    if (!hasNumber($credentials["password"])) {
		array_push($errors, [
			"error" => "Hasło musi zawierać cyfrę",
			"type" => "password",
		]);
	}

	if ($credentials["password"] != $credentials["password2"]) {
		array_push($errors, [
			"error" => "Hasła nie są zgodne",
			"type" => "password2",
		]);
	}

	// if (!$credentials["terms"]) {
	// 	array_push($errors, [
	// 		"error" => "Musisz zaakceptować Regulamin",
	// 		"type" => "terms",
	// 	]);
	// }

	// if (!$credentials["privacy"]) {
	// 	array_push($errors, [
	// 		"error" => "Musisz zaakceptować Politykę Prywatności",
	// 		"type" => "privacy",
	// 	]);
	// }

	if (!empty($errors)) {
		http_response_code(400);
		exit(json_encode(["errors" => $errors], JSON_UNESCAPED_UNICODE));
	}
}


if (!isset($inputJson)) {
    http_response_code(400);
    exit();
}

verify($inputJson);

$passwordHash = password_hash($inputJson["password"], PASSWORD_DEFAULT);
createUser($inputJson["mail"], $inputJson["username"], $passwordHash);

http_response_code(200);
header("Content-Type: application/json");
exit(json_encode(["userId" => $_SESSION["userId"]]));