<?php

declare(strict_types=1);

namespace App\Repository;

use App\Entity\UserCardState;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<UserCardState>
 */
final class UserCardStateRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, UserCardState::class);
    }
}
