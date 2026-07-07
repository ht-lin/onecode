<?php

declare(strict_types=1);

namespace App\Tests\Entity;

use App\Entity\Card;
use App\Enum\CardKind;

final class CardTest extends EntityTestCase
{
    public function testSoftDeleteKeepsTombstoneAndBumpsUpdatedAt(): void
    {
        $owner = $this->makeUser('anna');
        $card = $this->makeCard($owner);
        $this->em->persist($owner);
        $this->em->persist($card);
        $this->em->flush();

        $updatedAtBeforeDelete = $card->getUpdatedAt();
        $card->markDeleted();
        $this->em->flush();
        $cardId = $card->getId();
        $this->em->clear();

        // 墓碑仍在库中可查（同步协议需要下发给客户端，§6.4），
        // 且 updated_at 被服务端时钟刷新，保证墓碑能通过游标增量下发。
        $tombstone = $this->em->find(Card::class, $cardId);
        self::assertNotNull($tombstone);
        self::assertTrue($tombstone->isDeleted());
        self::assertGreaterThan($updatedAtBeforeDelete, $tombstone->getUpdatedAt());
    }

    public function testDefaultsMatchSpec(): void
    {
        $owner = $this->makeUser('anna');
        $card = $this->makeCard($owner);
        $this->em->persist($owner);
        $this->em->persist($card);
        $this->em->flush();
        $cardId = $card->getId();
        $this->em->clear();

        $reloaded = $this->em->find(Card::class, $cardId);
        self::assertNotNull($reloaded);
        self::assertSame(CardKind::Loyalty, $reloaded->getCardKind());
        self::assertSame('#4A6FA5', $reloaded->getColor());
        self::assertNull($reloaded->getNote());
        self::assertNull($reloaded->getExpiresAt());
        self::assertFalse($reloaded->isDeleted());
    }
}
