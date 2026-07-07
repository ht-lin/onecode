<?php

declare(strict_types=1);

namespace App\Tests\Api;

use ApiPlatform\Symfony\Bundle\Test\ApiTestCase;

final class HealthzTest extends ApiTestCase
{
    // Opt in to the API Platform 5.0 behavior to silence the 4.1 deprecation
    protected static ?bool $alwaysBootKernel = true;

    public function testHealthzReturnsOkWhenDatabaseIsReachable(): void
    {
        static::createClient()->request('GET', '/healthz');

        self::assertResponseIsSuccessful();
        self::assertJsonContains(['status' => 'ok', 'version' => 'dev']);
    }
}
