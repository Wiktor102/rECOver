<?php
require_once __DIR__ . "/../points.php";

function getUserQuizes($userId, $onlyNewest = false) {
    $conn = connect();
    $stmt = $conn->stmt_init();

    try {
        $sql = "SELECT * FROM `quizes` WHERE `user_id` = ? AND `date` >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH) ORDER BY `date` DESC";
        $sql .= $onlyNewest ? " LIMIT 1" : "";
        $stmt->prepare($sql);
        $stmt->bind_param("i", $userId);

        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows === 0) {
            return null;
        }

        $records = $result->fetch_all(MYSQLI_ASSOC);

        foreach ($records as &$record) {
            $record['questions'] = json_decode($record['questions'], true);
        }

        return $onlyNewest ? $records[0] : $records;
    } finally {
        $stmt->close();
        $conn->close();
    }
}

function getRandomQuestions($usedQuestions) {
    $conn = connect();
    $stmt = $conn->stmt_init();

    try {
        $placeholders = implode(",", array_fill(0, count($usedQuestions), "?"));
        $sql = "SELECT * FROM `quiz_questions` WHERE `id` NOT IN ($placeholders) ORDER BY RAND() LIMIT 3;";

        $stmt->prepare($sql);
        $stmt->bind_param(str_repeat("i", count($usedQuestions)), ...$usedQuestions);
        $stmt->execute();
        $result = $stmt->get_result();
        $questions = $result->fetch_all(MYSQLI_ASSOC);

        return $questions;
    } finally {
        $conn->close();
    }
}

function getQuizQuestions($questionsIds) {
    $conn = connect();
    $stmt = $conn->stmt_init();

    try {
        $placeholders = implode(",", array_fill(0, count($questionsIds), "?"));
        $sql = "SELECT * FROM `quiz_questions` WHERE `id` IN ($placeholders);";
        $stmt->prepare($sql);
        $stmt->bind_param(str_repeat("i", count($questionsIds)), ...$questionsIds);
        $stmt->execute();
        $result = $stmt->get_result();
        $questions = $result->fetch_all(MYSQLI_ASSOC);

        foreach ($questions as &$question) {
            $question['answers'] = json_decode($question['answers'], true);
        }

        return $questions;
    } finally {
        $stmt->close();
        $conn->close();
    }
}

function markQuizAsCompleted($quizId) {
    $conn = connect();
    $stmt = $conn->stmt_init();

    try {
        $sql = "UPDATE `quizes` SET `completed` = 1 WHERE `id` = ?;";
        $stmt->prepare($sql);
        $stmt->bind_param("i", $quizId);
        $stmt->execute();
    } finally {
        $stmt->close();
        $conn->close();
    }
}

$router->addRoute("POST", "/quiz", function () {
    global $credentials;

    $conn = connect();
    $stmt = $conn->stmt_init();
    $userId = $credentials["userId"];

    try {
        $previousQuizes = getUserQuizes($userId);
        $usedQuestions = [0];

        if ($previousQuizes != null) {
            foreach ($previousQuizes as $quiz) {
                if (!$quiz["completed"]) continue;
                if (isset($quiz['questions']) && is_array($quiz['questions'])) {
                    $usedQuestions = array_merge($usedQuestions, $quiz['questions']);
                }
            }
        }

        $questions =  getRandomQuestions($usedQuestions);

        if (count($questions) < 3) {
            http_response_code(503);
            exit();
        }

        $questionsIds = array_map(function ($question) {
            return $question['id'];
        }, $questions);

        $questionsIdsJson = json_encode($questionsIds);


        $sql = "INSERT INTO `quizes` (`user_id`, `date`, `questions`) VALUES (?, CURRENT_DATE(), ?);";
        $stmt->prepare($sql);
        $stmt->bind_param("is", $userId, $questionsIdsJson);
        $stmt->execute();

        $quizId = $stmt->insert_id;
        exit(json_encode([
            "quizId" => $quizId,
            "completed" => false,
            "questions" => $questions
        ]));
    } catch (Exception $e) {
        error_log($e->getMessage());
        http_response_code(500);
    } finally {
        $conn->close();
    }
});

$router->addRoute("GET", "/quiz", function () {
    global $credentials;

    try {
        $quiz = getUserQuizes($credentials["userId"], true);

        $today = date('Y-m-d');
        if ($quiz == null || $quiz['date'] !== $today) {
            http_response_code(404);
            exit();
        }

        http_response_code(200);
        exit(json_encode([
            "quizId" => $quiz["id"],
            "completed" => $quiz["completed"],
            "questions" => getQuizQuestions($quiz['questions'])
        ]));
    } catch (Exception $e) {
        error_log($e->getMessage());
        http_response_code(500);
    }
});

$router->addRoute("PATCH", "/quiz/check", function () {
    global $credentials;
    global $inputJson;

    try {
        $quiz = getUserQuizes($credentials["userId"], true);

        $today = date('Y-m-d');
        if ($quiz == null || $quiz['date'] !== $today) {
            http_response_code(404);
            exit();
        }

        $userAnswers = $inputJson['answers'];
        $points = 0;

        foreach ($userAnswers as $i => $userAnswer) {
            $question = getQuizQuestions($quiz["questions"])[$i];
            $correctAnswer = $question['answers']['options'][$question['answers']['correct_answer'] - 1];

            if ($correctAnswer === $userAnswer) $points++;
        }

        if ($points == 0) $points = 1;
        if ($points == 3) $points = 5;

        // markQuizAsCompleted($quiz["id"]);
        addPoints($credentials["userId"], $points);
        $pointsTotal = getPoints($credentials["userId"]);

        http_response_code(200);
        exit(json_encode([
            "points" => $points,
            "totalPoints" => $pointsTotal
        ]));
    } catch (Exception $e) {
        error_log($e->getMessage());
        http_response_code(500);
    }
});