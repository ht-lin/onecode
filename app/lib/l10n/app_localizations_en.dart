// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'OneCode';

  @override
  String get tabWallet => 'Wallet';

  @override
  String get tabFriends => 'Friends';

  @override
  String get tabSettings => 'Settings';

  @override
  String get editorTitleNew => 'Add card';

  @override
  String get editorTitleEdit => 'Edit card';

  @override
  String get editorCardNotFound => 'Card not found';

  @override
  String get fieldName => 'Name';

  @override
  String get errorNameRequired => 'Please enter a name';

  @override
  String get fieldCodeValue => 'Code value';

  @override
  String get errorCodeValueRequired => 'Please enter a code value';

  @override
  String get fieldCodeFormat => 'Code type';

  @override
  String get fieldCardKind => 'Card type';

  @override
  String get kindLoyalty => 'Loyalty card';

  @override
  String get kindCoupon => 'Coupon';

  @override
  String get fieldExpiry => 'Valid until';

  @override
  String get expiryNotSet => 'No expiry date';

  @override
  String get removeExpiry => 'Remove expiry date';

  @override
  String get fieldNote => 'Note';

  @override
  String get fieldColor => 'Card color';

  @override
  String get customColor => 'Custom color';

  @override
  String get colorHue => 'Hue';

  @override
  String get colorSaturation => 'Saturation';

  @override
  String get colorBrightness => 'Brightness';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get previewInvalid => 'Code preview unavailable';

  @override
  String codeIssueCharset(String format) {
    return 'Contains characters not allowed in $format';
  }

  @override
  String codeIssueLength(String format) {
    return 'Length does not match $format';
  }

  @override
  String codeIssueCheckDigit(String format) {
    return 'Check digit is not valid for $format';
  }

  @override
  String get forceSaveTitle => 'Save non-standard code?';

  @override
  String forceSaveBody(String format) {
    return 'The code value does not conform to $format. You can save it anyway — some scanners may not read it.';
  }

  @override
  String get forceSaveConfirm => 'Save anyway';

  @override
  String get addMenuScan => 'Scan barcode';

  @override
  String get addMenuGallery => 'Recognize from photo';

  @override
  String get addMenuManual => 'Enter manually';

  @override
  String get scanTitle => 'Scan code';

  @override
  String get scanHint => 'Align the code within the frame';

  @override
  String get scanTorchTooltip => 'Flashlight';

  @override
  String get scanPermissionRationale =>
      'OneCode uses the camera only to scan barcodes. Images are processed on your device and are never stored or uploaded.';

  @override
  String get scanPermissionAllow => 'Allow camera access';

  @override
  String get scanPermissionDeniedBody =>
      'To scan codes, please allow camera access in the system settings.';

  @override
  String get scanOpenSettings => 'Open settings';

  @override
  String get scanResultTitle => 'Code detected';

  @override
  String get scanUseCode => 'Use code';

  @override
  String get scanRescan => 'Scan again';

  @override
  String get imageCaptureTitle => 'Code from photo';

  @override
  String get imageNoCodeTitle => 'No code found';

  @override
  String get imageNoCodeBody =>
      'No code was detected in this image. The code may be blurry, too small, cropped, or the image may be heavily compressed. Try a different image or enter the code manually.';

  @override
  String get imagePickAnother => 'Choose another image';

  @override
  String get imageEnterManually => 'Enter code manually';

  @override
  String get imageMultiHint =>
      'Several codes were found. Select the one you want to save.';

  @override
  String get searchHint => 'Search by name or note';

  @override
  String get filterAll => 'All';

  @override
  String get filterExpired => 'Expired';

  @override
  String get noMatchingCards => 'No matching cards';

  @override
  String get emptyWalletTitle => 'No cards yet';

  @override
  String get emptyWalletBody =>
      'Add your first card — scan it, recognize it from a photo, or enter it manually.';

  @override
  String get emptyWalletAction => 'Add first card';

  @override
  String get cardActionFavorite => 'Add to favorites';

  @override
  String get cardActionUnfavorite => 'Remove from favorites';

  @override
  String get cardActionEdit => 'Edit';

  @override
  String get cardActionDelete => 'Delete';

  @override
  String get deleteConfirmTitle => 'Delete card?';

  @override
  String deleteConfirmBody(String name) {
    return '\"$name\" will be removed from your wallet.';
  }

  @override
  String get displayRotateTooltip => 'Rotate display';

  @override
  String get displayDetailsTooltip => 'Card details';

  @override
  String get notifChannelName => 'Expiry reminders';

  @override
  String get notifChannelDescription => 'Reminders before coupons expire';

  @override
  String get notifExpiresSoonTitle => 'Coupon expires soon';

  @override
  String notifExpiresSoonBody(String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$name expires in $_temp0.';
  }

  @override
  String get notifExpiresTodayTitle => 'Coupon expires today';

  @override
  String notifExpiresTodayBody(String name) {
    return '$name is only valid until today.';
  }

  @override
  String get settingsAccountSection => 'Account';

  @override
  String get settingsSignInTitle => 'Sign in';

  @override
  String get settingsSignInSubtitle =>
      'Sync your cards and share them with friends';

  @override
  String get settingsSignInComingSoon =>
      'Sign-in is coming in a future update.';

  @override
  String get settingsGeneralSection => 'General';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsAppearanceSystem => 'System';

  @override
  String get settingsAppearanceLight => 'Light';

  @override
  String get settingsAppearanceDark => 'Dark';

  @override
  String get settingsLegalSection => 'Legal';

  @override
  String get legalImpressum => 'Legal notice (Impressum)';

  @override
  String get legalPrivacy => 'Privacy policy';

  @override
  String get legalLicenses => 'Open source licenses';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsRemindersSection => 'Expiry reminders';

  @override
  String get settingsRemindersEnabled => 'Notify before expiry';

  @override
  String get settingsRemindersLeadDays => 'Days in advance';

  @override
  String settingsLeadDaysValue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String cleanupPromptBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count coupons expired more than 30 days ago.',
      one: '1 coupon expired more than 30 days ago.',
    );
    return '$_temp0';
  }

  @override
  String get cleanupPromptAction => 'Clean up';

  @override
  String get cleanupPromptLater => 'Not now';

  @override
  String get cleanupConfirmTitle => 'Delete expired coupons?';

  @override
  String cleanupConfirmBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count expired coupons will be removed from your wallet.',
      one: '1 expired coupon will be removed from your wallet.',
    );
    return '$_temp0';
  }
}
