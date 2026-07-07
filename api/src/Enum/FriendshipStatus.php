<?php

declare(strict_types=1);

namespace App\Enum;

/**
 * 好友请求状态（SPEC §6.2 friendship.status）。
 */
enum FriendshipStatus: string
{
    case Pending = 'pending';
    case Accepted = 'accepted';
    case Declined = 'declined';
}
