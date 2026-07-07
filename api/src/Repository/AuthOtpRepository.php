<?php

declare(strict_types=1);

namespace App\Repository;

use App\Entity\AuthOtp;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<AuthOtp>
 */
final class AuthOtpRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, AuthOtp::class);
    }
}
