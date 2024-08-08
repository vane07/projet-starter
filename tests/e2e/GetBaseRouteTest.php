<?php declare(strict_types=1);

use GuzzleHttp\Client;
use PHPUnit\Framework\TestCase;

final class GetBaseRouteTest extends TestCase
{
    public function testBaseRouteReturns200AndExpectedBody(): void
    {
        // arrange
        $client = new Client();
        $expected = [
            'data' => null,
            'message' => 'API is up'
        ];
        // act
        $response = $client->request('GET', 'http://localhost');
        $body = json_decode($response->getBody()->getContents(), true);
        // assert
        $this->assertEquals(200, $response->getStatusCode());
        $this->assertEquals($response->getHeader('Content-Type')[0], 'application/json');
        $this->assertEquals($expected, $body);
    }
}