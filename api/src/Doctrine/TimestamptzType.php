<?php

declare(strict_types=1);

namespace App\Doctrine;

use Doctrine\DBAL\Platforms\AbstractPlatform;
use Doctrine\DBAL\Types\Exception\InvalidType;
use Doctrine\DBAL\Types\Exception\ValueNotConvertible;
use Doctrine\DBAL\Types\Type;

/**
 * PostgreSQL TIMESTAMPTZ with full microsecond precision.
 *
 * Doctrine's built-in datetimetz type declares TIMESTAMP(0) WITH TIME ZONE and
 * drops fractional seconds, but the sync cursor (SPEC §6.4) orders records by
 * a sub-second `updated_at`, so we keep the native precision.
 */
final class TimestamptzType extends Type
{
    public const NAME = 'timestamptz';

    public function getSQLDeclaration(array $column, AbstractPlatform $platform): string
    {
        return 'TIMESTAMPTZ';
    }

    public function convertToDatabaseValue(mixed $value, AbstractPlatform $platform): ?string
    {
        if (null === $value) {
            return null;
        }

        if ($value instanceof \DateTimeInterface) {
            return $value->format('Y-m-d H:i:s.uP');
        }

        throw InvalidType::new($value, self::NAME, ['null', \DateTimeInterface::class]);
    }

    public function convertToPHPValue(mixed $value, AbstractPlatform $platform): ?\DateTimeImmutable
    {
        if (null === $value || $value instanceof \DateTimeImmutable) {
            return $value;
        }

        if (!\is_string($value)) {
            throw ValueNotConvertible::new($value, \DateTimeImmutable::class);
        }

        try {
            return new \DateTimeImmutable($value);
        } catch (\Exception $e) {
            throw ValueNotConvertible::new($value, \DateTimeImmutable::class, $e->getMessage(), $e);
        }
    }
}
