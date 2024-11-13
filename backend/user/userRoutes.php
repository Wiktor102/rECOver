<?php
$router->addRoute("GET", "/user", function () {
    global $credentials;
    $userId = $credentials["userId"];

    $conn = connect();
    $stmt = $conn->stmt_init();

    try {
        $sql = "SELECT `id`, `email`, `nick`, `mainStreak`, `points`, `tags`, `streaks`, `quizQuestions` FROM `users` WHERE `id` = ?;";
        $stmt->prepare($sql);
        $stmt->bind_param("i", $userId);
        $stmt->execute();

        $result = $stmt->get_result();
        if ($result->num_rows == 0) {
            echo json_encode(["error" => "User not found"]);
            return;
        }

        exit(json_encode($result->fetch_assoc()));
    } catch (Exception $e) {
        echo json_encode(["error" => $e->getMessage()]);
    } finally {
        $stmt->close();
        $conn->close();
    }
});
