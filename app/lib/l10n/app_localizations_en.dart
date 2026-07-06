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
}
