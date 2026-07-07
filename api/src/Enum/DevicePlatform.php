<?php

declare(strict_types=1);

namespace App\Enum;

/**
 * 设备平台（SPEC §6.2 device.platform）。
 */
enum DevicePlatform: string
{
    case Ios = 'ios';
    case Android = 'android';
}
