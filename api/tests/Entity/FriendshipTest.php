<?php

declare(strict_types=1);

namespace App\Tests\Entity;

use App\Entity\Friendship;
use Doctrine\DBAL\Exception\UniqueConstraintViolationException;

final class FriendshipTest extends EntityTestCase
{
    public function testReversedPairViolatesPartialUniqueIndex(): void
    {
        $anna = $this->makeUser('anna');
        $ben = $this->makeUser('ben');
        $this->em->persist($anna);
        $this->em->persist($ben);
        $this->em->persist(new Friendship($anna, $ben));
        $this->em->flush();

        // 单行双向：反方向的第二条记录同样命中 LEAST/GREATEST 唯一索引
        $this->em->persist(new Friendship($ben, $anna));

        $this->expectException(UniqueConstraintViolationException::class);
        $this->em->flush();
    }

    public function testPairCanBeRecreatedAfterSoftDelete(): void
    {
        $anna = $this->makeUser('anna');
        $ben = $this->makeUser('ben');
        $first = new Friendship($anna, $ben);
        $this->em->persist($anna);
        $this->em->persist($ben);
        $this->em->persist($first);
        $this->em->flush();

        // 删除好友后重新加回：唯一索引只约束活跃行（WHERE deleted_at IS NULL）
        $first->markDeleted();
        $this->em->flush();

        $second = new Friendship($ben, $anna);
        $this->em->persist($second);
        $this->em->flush();

        self::assertFalse($second->isDeleted());
    }
}
