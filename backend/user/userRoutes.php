<?php
require_once __DIR__ . '/../calculateStreak.php';

$router->addRoute("GET", "/user", function () {
    global $credentials;
    $userId = $credentials["userId"];

    $conn = connect();
    $stmt = $conn->stmt_init();

    try {
        try {
            $streaks = calculateStreak($userId);
            saveStreaks($streaks);
        } catch (Exception $e) {
            echo json_encode(["error" => "Streaks: " . $e->getMessage()]);
            return;
        }

        $sql = "SELECT `id`, `email`, `nick`, `mainStreak`, `points`, `tags`, `streaks`, `quizQuestions` FROM `users` WHERE `id` = ?;";
        $stmt->prepare($sql);
        $stmt->bind_param("i", $userId);
        $stmt->execute();

        $result = $stmt->get_result();
        if ($result->num_rows == 0) {
            echo json_encode(["error" => "User not found"]);
            return;
        }

        $row = $result->fetch_assoc();

        exit(json_encode([
            "id" => $row["id"],
            "email" => $row["email"],
            "nick" => $row["nick"],
            "mainStreak" => $row["mainStreak"],
            "points" => $row["points"],
            "tags" => json_decode($row["tags"]),
            "streaks" => json_decode($row["streaks"]),
            "quizQuestions" => json_decode($row["quizQuestions"])
        ]));
    } catch (Exception $e) {
        echo json_encode(["error" => $e->getMessage()]);
    } finally {
        $conn->close();
    }
});

$router->addRoute("PATCH", "/user", function () {
    global $credentials;
    global $inputJson;
    $userId = $credentials["userId"];

    if (!isset($inputJson) || $inputJson === null) {
        http_response_code(400);
        exit();
    }

    $allowedKeys = ["tags", "streaks", "quizQuestions"];
    foreach ($inputJson as $key => $value) {
        if (!in_array($key, $allowedKeys)) {
            echo json_encode(["error" => "Invalid key: $key"]);
            return;
        }
    }

    $conn = connect();
    $stmt = $conn->stmt_init();

    try {
        $setClause = [];
        $params = [];
        $types = "";

        foreach ($inputJson as $key => $value) {
            $setClause[] = "`$key` = ?";
            $params[] = is_array($value) ?  json_encode($value) : $value;
            $types .= is_int($value) ? "i" : "s";
        }

        $params[] = $userId;
        $types .= "i";

        $sql = "UPDATE `users` SET " . implode(", ", $setClause) . " WHERE `id` = ?;";

        $stmt->prepare($sql);
        $stmt->bind_param($types, ...$params);
        $stmt->execute();

        if ($stmt->affected_rows === 0) {
            http_response_code(404);
            echo json_encode(["error" => "No rows updated"]);
            return;
        }

        http_response_code(204);
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(["error" => $e->getMessage()]);
    } finally {
        $stmt->close();
        $conn->close();
    }
});
