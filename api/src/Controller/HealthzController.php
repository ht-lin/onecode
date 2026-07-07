<?php

declare(strict_types=1);

namespace App\Controller;

use Doctrine\DBAL\Connection;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Attribute\Route;

/**
 * Liveness probe (SPEC §7): public, no authentication, checks DB connectivity.
 */
final class HealthzController
{
    #[Route('/healthz', name: 'healthz', methods: ['GET'])]
    public function __invoke(Connection $connection): JsonResponse
    {
        // Baked into the image by CI (git SHA) so deploys can verify the running version
        $version = getenv('APP_VERSION') ?: 'dev';

        try {
            $connection->executeQuery('SELECT 1')->fetchOne();
        } catch (\Throwable) {
            return new JsonResponse(['status' => 'error', 'version' => $version], JsonResponse::HTTP_SERVICE_UNAVAILABLE);
        }

        return new JsonResponse(['status' => 'ok', 'version' => $version]);
    }
}
