<?php

declare(strict_types=1);

namespace App\Doctrine;

use Doctrine\DBAL\Platforms\AbstractPlatform;
use Doctrine\DBAL\Types\TextType;

/**
 * PostgreSQL CITEXT: case-insensitive text, used for email/username so the
 * UNIQUE constraints are case-insensitive at the database level (SPEC §6.2).
 */
final class CitextType extends TextType
{
    public const NAME = 'citext';

    public function getSQLDeclaration(array $column, AbstractPlatform $platform): string
    {
        return 'CITEXT';
    }
}
