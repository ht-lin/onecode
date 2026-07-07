<?php

declare(strict_types=1);

namespace App\Enum;

/**
 * 卡类型（SPEC §3.2）：会员卡（无有效期）/ 优惠券（可设有效期）。
 */
enum CardKind: string
{
    case Loyalty = 'loyalty';
    case Coupon = 'coupon';
}
