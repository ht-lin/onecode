<?php

declare(strict_types=1);

namespace App\Entity\Behavior;

use Doctrine\ORM\Mapping as ORM;

/**
 * 软删除墓碑（SPEC §6.1）。
 *
 * 行为上是"标记"而非过滤：墓碑仍可查询，供同步协议下发给客户端
 * （§6.4），90 天后由定时任务硬删除。软删除触发 PreUpdate，因此
 * updated_at 同步刷新，墓碑能通过游标增量下发。
 */
trait SoftDeletableTrait
{
    #[ORM\Column(type: 'timestamptz', nullable: true)]
    private ?\DateTimeImmutable $deletedAt = null;

    public function getDeletedAt(): ?\DateTimeImmutable
    {
        return $this->deletedAt;
    }

    public function isDeleted(): bool
    {
        return null !== $this->deletedAt;
    }

    public function markDeleted(): void
    {
        $this->deletedAt ??= new \DateTimeImmutable();
    }
}
