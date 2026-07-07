<?php

declare(strict_types=1);

namespace App\Entity;

use App\Entity\Behavior\SoftDeletableTrait;
use App\Entity\Behavior\TimestampedTrait;
use App\Enum\FriendshipStatus;
use App\Repository\FriendshipRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Bridge\Doctrine\Types\UuidType;
use Symfony\Component\Uid\Uuid;

/**
 * 好友关系，单行双向（SPEC §6.2 friendship）。deleted_at = 已删除好友。
 *
 * 每对用户最多一行活跃记录，由数据库层的部分唯一索引保证
 * （LEAST/GREATEST 表达式索引，Doctrine 无法用属性表达，
 * 见迁移 uniq_friendship_pair_active 的原生 SQL）。
 */
#[ORM\Entity(repositoryClass: FriendshipRepository::class)]
#[ORM\HasLifecycleCallbacks]
class Friendship
{
    use TimestampedTrait;
    use SoftDeletableTrait;

    #[ORM\Id]
    #[ORM\Column(type: UuidType::NAME)]
    private Uuid $id;

    #[ORM\ManyToOne]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private UserAccount $requester;

    #[ORM\ManyToOne]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private UserAccount $addressee;

    #[ORM\Column(type: Types::TEXT, enumType: FriendshipStatus::class)]
    private FriendshipStatus $status = FriendshipStatus::Pending;

    public function __construct(UserAccount $requester, UserAccount $addressee)
    {
        $this->id = Uuid::v4();
        $this->requester = $requester;
        $this->addressee = $addressee;
    }

    public function getId(): Uuid
    {
        return $this->id;
    }

    public function getRequester(): UserAccount
    {
        return $this->requester;
    }

    public function getAddressee(): UserAccount
    {
        return $this->addressee;
    }

    public function getStatus(): FriendshipStatus
    {
        return $this->status;
    }

    public function accept(): void
    {
        $this->status = FriendshipStatus::Accepted;
    }

    public function decline(): void
    {
        $this->status = FriendshipStatus::Declined;
    }
}
