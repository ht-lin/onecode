<?php

declare(strict_types=1);

namespace App\Entity\Behavior;

use Doctrine\ORM\Mapping as ORM;

/**
 * created_at / updated_at（SPEC §6.1）。
 *
 * `updated_at` 由服务端时钟在每次 flush 时覆盖写入——即使客户端在同步
 * 上行里携带了自己的时间戳，落库值也总是服务端时间（LWW 冲突判定与
 * 同步游标都依赖这一点）。宿主实体需标注 #[ORM\HasLifecycleCallbacks]。
 */
trait TimestampedTrait
{
    #[ORM\Column(type: 'timestamptz')]
    private \DateTimeImmutable $createdAt;

    #[ORM\Column(type: 'timestamptz')]
    private \DateTimeImmutable $updatedAt;

    #[ORM\PrePersist]
    public function initializeTimestamps(): void
    {
        $now = new \DateTimeImmutable();
        $this->createdAt = $now;
        $this->updatedAt = $now;
    }

    #[ORM\PreUpdate]
    public function touchUpdatedAt(): void
    {
        $this->updatedAt = new \DateTimeImmutable();
    }

    public function getCreatedAt(): \DateTimeImmutable
    {
        return $this->createdAt;
    }

    public function getUpdatedAt(): \DateTimeImmutable
    {
        return $this->updatedAt;
    }
}
