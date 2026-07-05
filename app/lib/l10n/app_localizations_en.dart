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
}
