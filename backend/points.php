<?php
function addPoints($userId, $points) {
    $conn = connect();
    $stmt = $conn->stmt_init();

    try {
        $sql = "UPDATE `users` SET `points` = `points` + ? WHERE `id` = ?;";
        $stmt->prepare($sql);
        $stmt->bind_param("ii", $points, $userId);
        $stmt->execute();
    } finally {
        $stmt->close();
        $conn->close();
    }
}

function getPoints($userId) {
    $conn = connect();
    $stmt = $conn->stmt_init();

    try {
        $sql = "SELECT `points` FROM `users` WHERE `id` = ?;";
        $stmt->prepare($sql);
        $stmt->bind_param("i", $userId);
        $stmt->execute();
        $result = $stmt->get_result();
        $points = $result->fetch_assoc()['points'];

        return $points;
    } finally {
        $stmt->close();
        $conn->close();
    }
}