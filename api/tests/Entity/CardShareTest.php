<?php

declare(strict_types=1);

namespace App\Tests\Entity;

use App\Entity\CardShare;
use Doctrine\DBAL\Exception\UniqueConstraintViolationException;

final class CardShareTest extends EntityTestCase
{
    public function testDuplicateActiveShareViolatesPartialUniqueIndex(): void
    {
        $owner = $this->makeUser('anna');
        $recipient = $this->makeUser('ben');
        $card = $this->makeCard($owner);
        $this->em->persist($owner);
        $this->em->persist($recipient);
        $this->em->persist($card);
        $this->em->persist(new CardShare($card, $recipient));
        $this->em->flush();

        $this->em->persist(new CardShare($card, $recipient));

        $this->expectException(UniqueConstraintViolationException::class);
        $this->em->flush();
    }

    public function testCardCanBeResharedAfterRevocation(): void
    {
        $owner = $this->makeUser('anna');
        $recipient = $this->makeUser('ben');
        $card = $this->makeCard($owner);
        $first = new CardShare($card, $recipient);
        $this->em->persist($owner);
        $this->em->persist($recipient);
        $this->em->persist($card);
        $this->em->persist($first);
        $this->em->flush();

        // 撤回（§8.2）产生墓碑后，同一张卡可以再次共享给同一个人
        $first->markDeleted();
        $this->em->flush();

        $second = new CardShare($card, $recipient);
        $this->em->persist($second);
        $this->em->flush();

        self::assertFalse($second->isDeleted());
    }
}
