<?php

declare(strict_types=1);

namespace App\Enum;

/**
 * 卡共享状态（SPEC §6.2 card_share.status）。
 */
enum CardShareStatus: string
{
    case Pending = 'pending';
    case Accepted = 'accepted';
}
