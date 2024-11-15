<?php
require_once 'connect.php';

if(php_sapi_name() != 'cli'){
    http_response_code(403);
    return;
}

$conn = connect();
$stmt = $conn->stmt_init();

try {
    $sql = "SELECT * FROM `possible_records`;";
    $result = $conn->query($sql);
    $allPossibleRecords = $result->fetch_all(MYSQLI_ASSOC);

    $sql = "SELECT * FROM `records` WHERE `date` = CURDATE() - INTERVAL 1 DAY;";
    $result = $conn->query($sql);
    $userPoints = [];

    while ($row = $result->fetch_assoc()) {
        $userId = $row['user_id'];
        $transport = json_decode($row['usedTransport'], true);
        $other = json_decode($row['achievements'], true);

        $points = 0;

        if (in_array("cycle", $transport)) {
            $points += 2;
        }

        if (in_array("car", $transport)) {
            $points -= 1;
        }

        if (in_array("bus", $transport)) {
            $points += 1;
        }

        if (in_array("train", $transport)) {
            $points += 2;
        }

        if (in_array("airplane", $transport)) {
            $points -= 5;
        }

        foreach ($allPossibleRecords as $record) {
            if (in_array($record['id'], $other)) {
                $points += $record['pointsBase'];
            }
        }

        $userPoints[$userId] = $points;
    }


    foreach ($userPoints as $userId => $points) {
        $sql = "UPDATE `users` SET `points` = `points` + ? WHERE `id` = ?;";
        $stmt->prepare($sql);
        $stmt->bind_param("ii", $points, $userId);
        $stmt->execute();
    }
} finally {
    $conn->close();
}