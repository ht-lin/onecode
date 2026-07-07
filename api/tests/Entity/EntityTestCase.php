<?php

declare(strict_types=1);

namespace App\Tests\Entity;

use App\Entity\Card;
use App\Entity\UserAccount;
use App\Enum\CodeFormat;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Test\KernelTestCase;
use Symfony\Component\Uid\Uuid;

/**
 * 实体级测试基类：真实 Postgres 测试库，
 * DAMA 扩展把每个测试包在回滚事务里，测试间互不污染。
 */
abstract class EntityTestCase extends KernelTestCase
{
    protected EntityManagerInterface $em;

    protected function setUp(): void
    {
        self::bootKernel();
        $this->em = self::getContainer()->get(EntityManagerInterface::class);
    }

    protected function makeUser(string $handle): UserAccount
    {
        return new UserAccount($handle.'@example.com', $handle, ucfirst($handle));
    }

    protected function makeCard(UserAccount $owner, string $name = 'REWE'): Card
    {
        return new Card(Uuid::v4(), $owner, $name, '4023600123456', CodeFormat::Ean13);
    }
}
