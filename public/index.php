<?php declare(strict_types=1);

require_once __DIR__ . '/../vendor/autoload.php';

use App\Controllers\BaseController;

$controller = new BaseController();

$response = $controller->index();

header('Content-Type: application/json');
echo json_encode($response);