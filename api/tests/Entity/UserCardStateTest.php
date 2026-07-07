<?php

declare(strict_types=1);

namespace App\Tests\Entity;

use App\Entity\UserCardState;
use Doctrine\DBAL\Exception\UniqueConstraintViolationException;

final class UserCardStateTest extends EntityTestCase
{
    public function testCompositePrimaryKeyRejectsDuplicatePair(): void
    {
        $owner = $this->makeUser('anna');
        $card = $this->makeCard($owner);
        $this->em->persist($owner);
        $this->em->persist($card);
        $this->em->persist(new UserCardState($owner, $card));
        $this->em->flush();
        $this->em->clear();

        $ownerRef = $this->em->find($owner::class, $owner->getId());
        $cardRef = $this->em->find($card::class, $card->getId());
        self::assertNotNull($ownerRef);
        self::assertNotNull($cardRef);
        $this->em->persist(new UserCardState($ownerRef, $cardRef));

        $this->expectException(UniqueConstraintViolationException::class);
        $this->em->flush();
    }

    public function testFavoriteDefaultsToFalseAndCanBeToggled(): void
    {
        $owner = $this->makeUser('anna');
        $card = $this->makeCard($owner);
        $state = new UserCardState($owner, $card);
        $this->em->persist($owner);
        $this->em->persist($card);
        $this->em->persist($state);
        $this->em->flush();

        self::assertFalse($state->isFavorite());
        self::assertNull($state->getLastUsedAt());

        $updatedAtBefore = $state->getUpdatedAt();
        $state->setFavorite(true);
        $state->markUsed();
        $this->em->flush();

        self::assertTrue($state->isFavorite());
        self::assertNotNull($state->getLastUsedAt());
        self::assertGreaterThan($updatedAtBefore, $state->getUpdatedAt());
    }
}
