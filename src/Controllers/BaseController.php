<?php declare(strict_types=1);

namespace App\Controllers;

final class BaseController
{
    public function index(): array
    {
        return [
            'data' => null,
            'message' => 'API is up'
        ];
    }
}
