<?php

declare(strict_types=1);

namespace App\Entity;

use App\Entity\Behavior\SoftDeletableTrait;
use App\Entity\Behavior\TimestampedTrait;
use App\Enum\CardKind;
use App\Enum\CodeFormat;
use App\Repository\CardRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Bridge\Doctrine\Types\UuidType;
use Symfony\Component\Uid\Uuid;

/**
 * 卡（SPEC §6.2 card）。
 *
 * 主键 UUID v4 由客户端生成（§6.1，离线创建、天然幂等），
 * 因此构造函数要求显式传入 id。
 * (owner_id, updated_at) 索引服务于同步下行查询（§6.4）。
 */
#[ORM\Entity(repositoryClass: CardRepository::class)]
#[ORM\Index(name: 'idx_card_owner_updated_at', columns: ['owner_id', 'updated_at'])]
#[ORM\HasLifecycleCallbacks]
class Card
{
    use TimestampedTrait;
    use SoftDeletableTrait;

    #[ORM\Id]
    #[ORM\Column(type: UuidType::NAME)]
    private Uuid $id;

    #[ORM\ManyToOne]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private UserAccount $owner;

    #[ORM\Column(type: Types::TEXT)]
    private string $name;

    #[ORM\Column(type: Types::TEXT)]
    private string $codeValue;

    #[ORM\Column(type: Types::TEXT, enumType: CodeFormat::class)]
    private CodeFormat $codeFormat;

    #[ORM\Column(type: Types::TEXT, enumType: CardKind::class, options: ['default' => 'loyalty'])]
    private CardKind $cardKind = CardKind::Loyalty;

    #[ORM\Column(type: Types::TEXT, options: ['default' => '#4A6FA5'])]
    private string $color = '#4A6FA5';

    #[ORM\Column(type: Types::TEXT, nullable: true)]
    private ?string $note = null;

    /** 仅优惠券可设有效期（§3.2）。 */
    #[ORM\Column(type: Types::DATE_IMMUTABLE, nullable: true)]
    private ?\DateTimeImmutable $expiresAt = null;

    public function __construct(Uuid $id, UserAccount $owner, string $name, string $codeValue, CodeFormat $codeFormat)
    {
        $this->id = $id;
        $this->owner = $owner;
        $this->name = $name;
        $this->codeValue = $codeValue;
        $this->codeFormat = $codeFormat;
    }

    public function getId(): Uuid
    {
        return $this->id;
    }

    public function getOwner(): UserAccount
    {
        return $this->owner;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function setName(string $name): void
    {
        $this->name = $name;
    }

    public function getCodeValue(): string
    {
        return $this->codeValue;
    }

    public function setCodeValue(string $codeValue): void
    {
        $this->codeValue = $codeValue;
    }

    public function getCodeFormat(): CodeFormat
    {
        return $this->codeFormat;
    }

    public function setCodeFormat(CodeFormat $codeFormat): void
    {
        $this->codeFormat = $codeFormat;
    }

    public function getCardKind(): CardKind
    {
        return $this->cardKind;
    }

    public function setCardKind(CardKind $cardKind): void
    {
        $this->cardKind = $cardKind;
    }

    public function getColor(): string
    {
        return $this->color;
    }

    public function setColor(string $color): void
    {
        $this->color = $color;
    }

    public function getNote(): ?string
    {
        return $this->note;
    }

    public function setNote(?string $note): void
    {
        $this->note = $note;
    }

    public function getExpiresAt(): ?\DateTimeImmutable
    {
        return $this->expiresAt;
    }

    public function setExpiresAt(?\DateTimeImmutable $expiresAt): void
    {
        $this->expiresAt = $expiresAt;
    }
}
