<?php

declare(strict_types=1);

namespace App\Enum;

/**
 * 码制（SPEC §3.1，全部 13 种）。
 *
 * Wire 值与客户端 `app/lib/data/drift/enums.dart` 保持一致，
 * 同时用作数据库存储值与同步协议值。
 */
enum CodeFormat: string
{
    case QrCode = 'qr_code';
    case Aztec = 'aztec';
    case DataMatrix = 'data_matrix';
    case Pdf417 = 'pdf417';
    case Ean13 = 'ean13';
    case Ean8 = 'ean8';
    case UpcA = 'upc_a';
    case UpcE = 'upc_e';
    case Code128 = 'code128';
    case Code39 = 'code39';
    case Code93 = 'code93';
    case Itf = 'itf';
    case Codabar = 'codabar';
}
