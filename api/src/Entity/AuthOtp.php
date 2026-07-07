<?php

declare(strict_types=1);

namespace App\Entity;

use App\Repository\AuthOtpRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Bridge\Doctrine\Types\UuidType;
use Symfony\Component\Uid\Uuid;

/**
 * OTP 登录码（SPEC §6.2 auth_otp）。
 *
 * 验证码明文只出现在邮件里，库中仅存 argon2id 哈希。
 * 生命周期短（过期即失效），无 updated_at / 软删除。
 */
#[ORM\Entity(repositoryClass: AuthOtpRepository::class)]
class AuthOtp
{
    #[ORM\Id]
    #[ORM\Column(type: UuidType::NAME)]
    private Uuid $id;

    #[ORM\Column(type: 'citext')]
    private string $email;

    #[ORM\Column(type: Types::TEXT)]
    private string $codeHash;

    #[ORM\Column(type: 'timestamptz')]
    private \DateTimeImmutable $expiresAt;

    #[ORM\Column(type: Types::SMALLINT, options: ['default' => 0])]
    private int $attempts = 0;

    #[ORM\Column(type: 'timestamptz', nullable: true)]
    private ?\DateTimeImmutable $consumedAt = null;

    #[ORM\Column(type: 'timestamptz')]
    private \DateTimeImmutable $createdAt;

    public function __construct(string $email, string $codeHash, \DateTimeImmutable $expiresAt)
    {
        $this->id = Uuid::v4();
        $this->email = $email;
        $this->codeHash = $codeHash;
        $this->expiresAt = $expiresAt;
        $this->createdAt = new \DateTimeImmutable();
    }

    public function getId(): Uuid
    {
        return $this->id;
    }

    public function getEmail(): string
    {
        return $this->email;
    }

    public function getCodeHash(): string
    {
        return $this->codeHash;
    }

    public function getExpiresAt(): \DateTimeImmutable
    {
        return $this->expiresAt;
    }

    public function isExpired(?\DateTimeImmutable $now = null): bool
    {
        return ($now ?? new \DateTimeImmutable()) >= $this->expiresAt;
    }

    public function getAttempts(): int
    {
        return $this->attempts;
    }

    public function registerFailedAttempt(): int
    {
        return ++$this->attempts;
    }

    public function isConsumed(): bool
    {
        return null !== $this->consumedAt;
    }

    public function consume(): void
    {
        $this->consumedAt ??= new \DateTimeImmutable();
    }

    public function getCreatedAt(): \DateTimeImmutable
    {
        return $this->createdAt;
    }
}
