<?php
class Router {
    private $routes = [];

    public function addRoute($method, $path, $callback) {
        $this->routes[] = [
            "method" => $method,
            "path" => $path,
            "callback" => $callback,
        ];
    }

    public function handleRequest($method, $path) {
        $routeFound = false;

        foreach ($this->routes as $route) {
            if ($route["method"] === $method) {
                $pattern = $this->preparePattern($route["path"]);
                if (preg_match($pattern, $path, $matches)) {
                    $params = $this->extractParams($route["path"], $matches);
                    $callback = $route["callback"];
                    if (is_callable($callback)) {
                        $callback($params);

                        if (!headers_sent()) {
                            http_response_code(200);
                        }
                        return;
                    }
                }
            }
        }

        if ($routeFound) {
            http_response_code(405);
        } else {
            http_response_code(404);
        }
    }

    private function preparePattern($path) {
        // Match both required and optional parameters
        $pattern = preg_replace("/\/:\?(\w+)/", "(?:\/(?<$1>[^\/]+))?", $path);
        $pattern = preg_replace("/:(\w+)/", "(?<$1>[^\/]+)", $pattern);
        return "@^" . $pattern . "$@";
    }

    private function extractParams($routePath, $matches) {
        $params = [];
        $keys = [];

        // Match both required and optional parameters
        preg_match_all("/:\??(\w+)/", $routePath, $keys);
        $keys = $keys[1]; // Extract the parameter names

        foreach ($keys as $key) {
            if (isset($matches[$key])) {
                $params[$key] = $matches[$key];
            } else {
                $params[$key] = null; // Set to null if not matched
            }
        }

        return $params;
    }
}
