<?php
$router->addRoute("POST", "/auth/login", function () {
    require_once "./logIn.php";
});

$router->addRoute("GET", "/auth/logout", function () {
    require_once "./logOut.php";
});

$router->addRoute("POST", "/auth/signup", function () {
    require_once "./signUp.php";
});