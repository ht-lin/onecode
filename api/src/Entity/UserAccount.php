<?php

declare(strict_types=1);

namespace App\Entity;

use App\Entity\Behavior\TimestampedTrait;
use App\Repository\UserAccountRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Bridge\Doctrine\Types\UuidType;
use Symfony\Component\Uid\Uuid;

/**
 * 用户账号（SPEC §6.2 user_account）。
 *
 * email/username 用 CITEXT，唯一约束在数据库层即大小写不敏感。
 * username 的格式规则（3-20 位 [a-z0-9_]）在注册流程做应用层校验（M2-02）。
 * 无软删除：账号删除是 GDPR 硬删除（§9.3），级联清空所有关联数据。
 */
#[ORM\Entity(repositoryClass: UserAccountRepository::class)]
#[ORM\HasLifecycleCallbacks]
class UserAccount
{
    use TimestampedTrait;

    #[ORM\Id]
    #[ORM\Column(type: UuidType::NAME)]
    private Uuid $id;

    #[ORM\Column(type: 'citext', unique: true)]
    private string $email;

    #[ORM\Column(type: 'citext', unique: true)]
    private string $username;

    #[ORM\Column(type: Types::TEXT)]
    private string $displayName;

    #[ORM\Column(type: Types::TEXT, options: ['default' => 'de'])]
    private string $locale = 'de';

    public function __construct(string $email, string $username, string $displayName, string $locale = 'de')
    {
        $this->id = Uuid::v4();
        $this->email = $email;
        $this->username = $username;
        $this->displayName = $displayName;
        $this->locale = $locale;
    }

    public function getId(): Uuid
    {
        return $this->id;
    }

    public function getEmail(): string
    {
        return $this->email;
    }

    public function getUsername(): string
    {
        return $this->username;
    }

    public function getDisplayName(): string
    {
        return $this->displayName;
    }

    public function setDisplayName(string $displayName): void
    {
        $this->displayName = $displayName;
    }

    public function getLocale(): string
    {
        return $this->locale;
    }

    public function setLocale(string $locale): void
    {
        $this->locale = $locale;
    }
}
