<?php

// Piszę to PHP w formie REST api
// wszystkie zapytania będą kierowane do tego samego pliku (index.php)
// i w zależności od ścieżki będą wywoływane różne funkcje
// Czyli np do zalogowania będzie ścieżka /auth/login

require_once './vendor/autoload.php';
require_once "./auth/verifyJWT.php";
require_once "./connect.php";

// Sprawdzamy poprawność tokenu tylko jeśli nie jesteśmy w ścieżce /auth (no bo jeżeli logujemy to nie ma jeszcze tokenu)
if (!str_contains($path, "auth")) {
    $credentials = verifyJWT();
}

$input = file_get_contents("php://input");
if ($input !== "" && @$_SERVER["CONTENT_TYPE"] === "application/json") {
    $inputJson = json_decode($input, true);

    if ($inputJson == null) {
        http_response_code(400);
        exit();
    }
}


mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

$router = new Router();

require_once "./auth/authRoutes.php";

$router->handleRequest($_SERVER["REQUEST_METHOD"], $path);
