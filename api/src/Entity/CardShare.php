<?php

declare(strict_types=1);

namespace App\Entity;

use App\Entity\Behavior\SoftDeletableTrait;
use App\Entity\Behavior\TimestampedTrait;
use App\Enum\CardShareStatus;
use App\Repository\CardShareRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Bridge\Doctrine\Types\UuidType;
use Symfony\Component\Uid\Uuid;

/**
 * 卡共享，实时引用（SPEC §6.2 card_share）。
 * deleted_at = 已撤回或接收方退出；墓碑经同步下发后接收端删除本地卡（§8.2）。
 *
 * 同一张卡对同一接收者最多一条活跃共享，由下方声明的部分唯一索引
 * 保证（WHERE deleted_at IS NULL，撤回后可再次共享）。
 */
#[ORM\Entity(repositoryClass: CardShareRepository::class)]
#[ORM\UniqueConstraint(name: 'uniq_card_share_active', columns: ['card_id', 'recipient_id'], options: ['where' => '(deleted_at IS NULL)'])]
#[ORM\HasLifecycleCallbacks]
class CardShare
{
    use TimestampedTrait;
    use SoftDeletableTrait;

    #[ORM\Id]
    #[ORM\Column(type: UuidType::NAME)]
    private Uuid $id;

    #[ORM\ManyToOne]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private Card $card;

    #[ORM\ManyToOne]
    #[ORM\JoinColumn(nullable: false, onDelete: 'CASCADE')]
    private UserAccount $recipient;

    #[ORM\Column(type: Types::TEXT, enumType: CardShareStatus::class)]
    private CardShareStatus $status = CardShareStatus::Pending;

    public function __construct(Card $card, UserAccount $recipient)
    {
        $this->id = Uuid::v4();
        $this->card = $card;
        $this->recipient = $recipient;
    }

    public function getId(): Uuid
    {
        return $this->id;
    }

    public function getCard(): Card
    {
        return $this->card;
    }

    public function getRecipient(): UserAccount
    {
        return $this->recipient;
    }

    public function getStatus(): CardShareStatus
    {
        return $this->status;
    }

    public function accept(): void
    {
        $this->status = CardShareStatus::Accepted;
    }
}
