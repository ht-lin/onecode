<?php

declare(strict_types=1);

namespace App\Entity;

use App\Enum\DevicePlatform;
use App\Repository\DeviceRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Bridge\Doctrine\Types\UuidType;
use Symfony\Component\Uid\Uuid;

/**
 * 设备 = FCM 推送目标（SPEC §6.2 device）。
 */
#[ORM\Entity(repositoryClass: DeviceRepository::class)]
class Device
{
    #[ORM\Id]
    #[ORM\Column(type: UuidType::NAME)]
    private Uuid $id;

    #[ORM\ManyToOne]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private UserAccount $user;

    #[ORM\Column(type: Types::TEXT, enumType: DevicePlatform::class)]
    private DevicePlatform $platform;

    #[ORM\Column(type: Types::TEXT)]
    private string $pushToken;

    #[ORM\Column(type: Types::TEXT)]
    private string $appVersion;

    #[ORM\Column(type: 'timestamptz')]
    private \DateTimeImmutable $lastSeenAt;

    #[ORM\Column(type: 'timestamptz')]
    private \DateTimeImmutable $createdAt;

    public function __construct(UserAccount $user, DevicePlatform $platform, string $pushToken, string $appVersion)
    {
        $this->id = Uuid::v4();
        $this->user = $user;
        $this->platform = $platform;
        $this->pushToken = $pushToken;
        $this->appVersion = $appVersion;
        $now = new \DateTimeImmutable();
        $this->lastSeenAt = $now;
        $this->createdAt = $now;
    }

    public function getId(): Uuid
    {
        return $this->id;
    }

    public function getUser(): UserAccount
    {
        return $this->user;
    }

    public function getPlatform(): DevicePlatform
    {
        return $this->platform;
    }

    public function getPushToken(): string
    {
        return $this->pushToken;
    }

    public function setPushToken(string $pushToken): void
    {
        $this->pushToken = $pushToken;
    }

    public function getAppVersion(): string
    {
        return $this->appVersion;
    }

    public function setAppVersion(string $appVersion): void
    {
        $this->appVersion = $appVersion;
    }

    public function getLastSeenAt(): \DateTimeImmutable
    {
        return $this->lastSeenAt;
    }

    public function touch(): void
    {
        $this->lastSeenAt = new \DateTimeImmutable();
    }

    public function getCreatedAt(): \DateTimeImmutable
    {
        return $this->createdAt;
    }
}
