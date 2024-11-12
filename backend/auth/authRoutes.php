<?php
$router->addRoute("POST", "/auth/login", function () {
    require_once __DIR__ . "./logIn.php";
});

$router->addRoute("GET", "/auth/logout", function () {
    require_once __DIR__ . "/logOut.php";
});

$router->addRoute("POST", "/auth/signup", function () {
    require_once __DIR__ . "./signUp.php";
});