<?php

declare(strict_types=1);

namespace App\Entity;

use App\Repository\RefreshTokenRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Bridge\Doctrine\Types\UuidType;
use Symfony\Component\Uid\Uuid;

/**
 * 刷新令牌（SPEC §6.2 refresh_token）：轮换 + 可吊销。
 *
 * 令牌明文只下发给客户端一次，库中仅存哈希。
 */
#[ORM\Entity(repositoryClass: RefreshTokenRepository::class)]
class RefreshToken
{
    #[ORM\Id]
    #[ORM\Column(type: UuidType::NAME)]
    private Uuid $id;

    #[ORM\ManyToOne]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private UserAccount $user;

    #[ORM\Column(type: Types::TEXT)]
    private string $tokenHash;

    #[ORM\ManyToOne]
    #[ORM\JoinColumn(nullable: true, onDelete: 'SET NULL')]
    private ?Device $device;

    #[ORM\Column(type: 'timestamptz')]
    private \DateTimeImmutable $expiresAt;

    #[ORM\Column(type: 'timestamptz', nullable: true)]
    private ?\DateTimeImmutable $revokedAt = null;

    #[ORM\Column(type: 'timestamptz')]
    private \DateTimeImmutable $createdAt;

    public function __construct(UserAccount $user, string $tokenHash, \DateTimeImmutable $expiresAt, ?Device $device = null)
    {
        $this->id = Uuid::v4();
        $this->user = $user;
        $this->tokenHash = $tokenHash;
        $this->expiresAt = $expiresAt;
        $this->device = $device;
        $this->createdAt = new \DateTimeImmutable();
    }

    public function getId(): Uuid
    {
        return $this->id;
    }

    public function getUser(): UserAccount
    {
        return $this->user;
    }

    public function getTokenHash(): string
    {
        return $this->tokenHash;
    }

    public function getDevice(): ?Device
    {
        return $this->device;
    }

    public function getExpiresAt(): \DateTimeImmutable
    {
        return $this->expiresAt;
    }

    public function isRevoked(): bool
    {
        return null !== $this->revokedAt;
    }

    public function revoke(): void
    {
        $this->revokedAt ??= new \DateTimeImmutable();
    }

    public function isActive(?\DateTimeImmutable $now = null): bool
    {
        return !$this->isRevoked() && ($now ?? new \DateTimeImmutable()) < $this->expiresAt;
    }

    public function getCreatedAt(): \DateTimeImmutable
    {
        return $this->createdAt;
    }
}
