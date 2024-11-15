<?php
$router->addRoute("PUT", "/records", function () {
    global $credentials;
    global $inputJson;

    $conn = connect();
    $stmt = $conn->stmt_init();
    $userId = $credentials["userId"];
    $usedTransport = $inputJson["usedTransport"] == null ? "[]" : json_encode($inputJson["usedTransport"]);
    $achievements = $inputJson["achievements"] == null ? "[]" : json_encode($inputJson["achievements"]);

    try {
        if (count($inputJson["usedTransport"]) == 0 && count($inputJson["achievements"]) == 0) {
            $sql = "DELETE FROM `records` WHERE `user_id` = ? AND `date` = CURRENT_DATE();";
            $stmt->prepare($sql);
            $stmt->bind_param("i", $userId);
            $stmt->execute();
            exit();
        }

        $sql = "UPDATE `records` SET usedTransport = ?, achievements = ? WHERE `user_id` = ? AND `date` = CURRENT_DATE();";
        $stmt->prepare($sql);
        $stmt->bind_param("ssi", $usedTransport, $achievements, $userId);
        $stmt->execute();

        if ($stmt->affected_rows === 0) {
            $sql = "INSERT INTO `records` (`user_id`, `date`, `usedTransport`, `achievements`) VALUES (?, CURRENT_DATE(), ?, ?);";
            $stmt->prepare($sql);
            $stmt->bind_param("iss", $userId, $usedTransport, $achievements);
            $stmt->execute();
        }

    } catch (Exception $e) {
        http_response_code(500);
    } finally {
        $stmt->close();
        $conn->close();
    }
});

$router->addRoute("GET", "/records", function () {
    global $credentials;

    $queryString = [];
    parse_str($_SERVER["QUERY_STRING"], $queryString);

    $conn = connect();
    $stmt = $conn->stmt_init();
    $userId = $credentials["userId"];

    try {
        $sql = "SELECT * FROM `records` WHERE `user_id` = ?";
        if (isset($queryString["date"])) {
            $sql .= $queryString["date"] == "today" ? " AND `date` = CURRENT_DATE();" : " AND `date` = ?";
        } else {
            $sql .= ";";
        }

        $stmt->prepare($sql);

        if (isset($queryString["date"]) && $queryString["date"] != "today") {
            $date = $queryString["date"];
            $stmt->bind_param("is", $userId, $date);
        } else {
            $stmt->bind_param("i", $userId);
        }

        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows === 0) {
            http_response_code(404);
            exit();
        }

        $records = $result->fetch_all(MYSQLI_ASSOC);

        foreach ($records as &$record) {
            $record['usedTransport'] = json_decode($record['usedTransport'], true);
            $record['achievements'] = json_decode($record['achievements'], true);
        }

        exit(json_encode($records));
    } catch (Exception $e) {
        http_response_code(500);
    } finally {
        $stmt->close();
        $conn->close();
    }
});