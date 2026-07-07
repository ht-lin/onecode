<?php

declare(strict_types=1);

namespace App\Entity;

use App\Entity\Behavior\SoftDeletableTrait;
use App\Repository\UserCardStateRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;

/**
 * 每用户卡状态（SPEC §6.2 user_card_state）：收藏等个人偏好，
 * owner 与共享接收方通用——这是同步协议里接收方唯一可写的实体（§6.4）。
 *
 * 复合主键 (user_id, card_id)，无 created_at（按 §6.2）。
 */
#[ORM\Entity(repositoryClass: UserCardStateRepository::class)]
#[ORM\HasLifecycleCallbacks]
class UserCardState
{
    use SoftDeletableTrait;

    #[ORM\Id]
    #[ORM\ManyToOne]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private UserAccount $user;

    #[ORM\Id]
    #[ORM\ManyToOne]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private Card $card;

    #[ORM\Column(type: Types::BOOLEAN, options: ['default' => false])]
    private bool $isFavorite = false;

    #[ORM\Column(type: 'timestamptz', nullable: true)]
    private ?\DateTimeImmutable $lastUsedAt = null;

    #[ORM\Column(type: 'timestamptz')]
    private \DateTimeImmutable $updatedAt;

    public function __construct(UserAccount $user, Card $card)
    {
        $this->user = $user;
        $this->card = $card;
        $this->updatedAt = new \DateTimeImmutable();
    }

    #[ORM\PreUpdate]
    public function touchUpdatedAt(): void
    {
        $this->updatedAt = new \DateTimeImmutable();
    }

    public function getUser(): UserAccount
    {
        return $this->user;
    }

    public function getCard(): Card
    {
        return $this->card;
    }

    public function isFavorite(): bool
    {
        return $this->isFavorite;
    }

    public function setFavorite(bool $isFavorite): void
    {
        $this->isFavorite = $isFavorite;
    }

    public function getLastUsedAt(): ?\DateTimeImmutable
    {
        return $this->lastUsedAt;
    }

    public function markUsed(): void
    {
        $this->lastUsedAt = new \DateTimeImmutable();
    }

    public function getUpdatedAt(): \DateTimeImmutable
    {
        return $this->updatedAt;
    }
}
