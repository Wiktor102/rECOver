<?php
require_once __DIR__ . '/connect.php';

function calculateStreak($userId = null) {
    $conn = connect();
    $yesterday = date('Y-m-d', strtotime('-1 day'));

    if ($userId !== null) {
        $sql = "SELECT * FROM `records` WHERE `user_id` = $userId ORDER BY `date` ASC;";
    } else {
        if(php_sapi_name() != 'cli'){
            http_response_code(403);
            exit();
        }
    
        $sql = "SELECT * FROM `records` ORDER BY `date` ASC;";
    }

    try {
        $result = $conn->query($sql);

        $records = [];
        while ($row = $result->fetch_assoc()) {
            $userId = $row['user_id'];
            $date = $row['date'];

            if (!isset($records[$userId])) {
                $records[$userId] = [];
            }
            $records[$userId][] = $date;
        }

        // Calculate streak for each user
        $streaks = [];
        foreach ($records as $userId => $dates) {
            $streak = 0;
            $yesterday = null;

            foreach ($dates as $date) {
                $currentDate = new DateTime($date);

                $today = new DateTime();
                if ($currentDate->format('Y-m-d') === $today->format('Y-m-d')) {
                    continue;
                }

                if ($yesterday !== null && $currentDate->diff($yesterday)->days > 1) {
                    // Break in the streak
                    $streak = 0;
                }

                // Increment streak if dates are consecutive or it's the first record
                $streak++;

                // Update yesterday to the current date
                $yesterday = $currentDate;
            }

            // Check if yesterday is recorded
            $today = new DateTime();
            $yesterdayDate = $today->sub(new DateInterval('P1D'))->format('Y-m-d');
            if ($yesterday !== null && $yesterday->format('Y-m-d') === $yesterdayDate) {
                // Yesterday is recorded, streak remains valid
                $streaks[$userId] = $streak;
            } else {
                // Yesterday is not recorded, streak stops at the last valid count
                $streaks[$userId] = 0;
            }
        }

        return $streaks;
    } finally {
        $conn->close();
    }
}

function saveStreaks($streaks) {
    $conn = connect();

    try {
        $sql = "UPDATE `users` SET `mainStreak` = ? WHERE `id` = ?;";
        $stmt = $conn->prepare($sql);

        foreach ($streaks as $userId => $streak) {
            $stmt->bind_param('ii', $streak, $userId);
            $stmt->execute();
        }

        $sql = "UPDATE `users` SET `mainStreak` = 0 WHERE `id` NOT IN (" . implode(',', array_keys($streaks)) . ");";
        $conn->query($sql);
    } finally {
        $conn->close();
    }
}

if(php_sapi_name() == 'cli'){
    $streaks = calculateStreak();
    saveStreaks($streaks);
}