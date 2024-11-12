<?php
$router->addRoute("POST", "/auth/login", function () {
    global $inputJson;
    require_once __DIR__ . "/logIn.php";
});

$router->addRoute("GET", "/auth/refreshToken", function () {
    require_once __DIR__ . "/getNewAccessToken.php";
});

$router->addRoute("GET", "/auth/logout", function () {
    require_once __DIR__ . "/logOut.php";
});

$router->addRoute("POST", "/auth/signup", function () {
    global $inputJson;
    require_once __DIR__ . "./signUp.php";
});