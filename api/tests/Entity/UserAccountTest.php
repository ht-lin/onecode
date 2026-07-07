<?php

declare(strict_types=1);

namespace App\Tests\Entity;

use App\Entity\UserAccount;
use Doctrine\DBAL\Exception\UniqueConstraintViolationException;

final class UserAccountTest extends EntityTestCase
{
    public function testEmailUniquenessIsCaseInsensitive(): void
    {
        $this->em->persist(new UserAccount('Anna@Example.com', 'anna', 'Anna'));
        $this->em->flush();

        $this->em->persist(new UserAccount('anna@example.com', 'anna2', 'Anna 2'));

        $this->expectException(UniqueConstraintViolationException::class);
        $this->em->flush();
    }

    public function testUsernameUniquenessIsCaseInsensitive(): void
    {
        $this->em->persist(new UserAccount('anna@example.com', 'anna', 'Anna'));
        $this->em->flush();

        $this->em->persist(new UserAccount('other@example.com', 'ANNA', 'Anna 2'));

        $this->expectException(UniqueConstraintViolationException::class);
        $this->em->flush();
    }

    public function testUpdatedAtIsBumpedByServerClockOnUpdate(): void
    {
        $user = $this->makeUser('anna');
        $this->em->persist($user);
        $this->em->flush();

        $createdAt = $user->getCreatedAt();
        $firstUpdatedAt = $user->getUpdatedAt();
        self::assertEquals($createdAt, $firstUpdatedAt);

        $user->setDisplayName('Anna Schmidt');
        $this->em->flush();

        self::assertGreaterThan($firstUpdatedAt, $user->getUpdatedAt());
        self::assertEquals($createdAt, $user->getCreatedAt());
    }
}
