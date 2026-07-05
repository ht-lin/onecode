// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'OneCode';

  @override
  String get tabWallet => 'Karten';

  @override
  String get tabFriends => 'Freunde';

  @override
  String get tabSettings => 'Einstellungen';

  @override
  String get editorTitleNew => 'Karte hinzufügen';

  @override
  String get editorTitleEdit => 'Karte bearbeiten';

  @override
  String get editorCardNotFound => 'Karte nicht gefunden';

  @override
  String get fieldName => 'Name';

  @override
  String get errorNameRequired => 'Bitte einen Namen eingeben';

  @override
  String get fieldCodeValue => 'Codewert';

  @override
  String get errorCodeValueRequired => 'Bitte einen Codewert eingeben';

  @override
  String get fieldCodeFormat => 'Codetyp';

  @override
  String get fieldCardKind => 'Kartentyp';

  @override
  String get kindLoyalty => 'Kundenkarte';

  @override
  String get kindCoupon => 'Gutschein';

  @override
  String get fieldExpiry => 'Gültig bis';

  @override
  String get expiryNotSet => 'Kein Ablaufdatum';

  @override
  String get removeExpiry => 'Ablaufdatum entfernen';

  @override
  String get fieldNote => 'Notiz';

  @override
  String get fieldColor => 'Kartenfarbe';

  @override
  String get customColor => 'Eigene Farbe';

  @override
  String get colorHue => 'Farbton';

  @override
  String get colorSaturation => 'Sättigung';

  @override
  String get colorBrightness => 'Helligkeit';

  @override
  String get actionSave => 'Speichern';

  @override
  String get actionCancel => 'Abbrechen';

  @override
  String get previewInvalid => 'Codevorschau nicht verfügbar';

  @override
  String codeIssueCharset(String format) {
    return 'Enthält Zeichen, die $format nicht erlaubt';
  }

  @override
  String codeIssueLength(String format) {
    return 'Länge passt nicht zu $format';
  }

  @override
  String codeIssueCheckDigit(String format) {
    return 'Prüfziffer ist für $format ungültig';
  }

  @override
  String get forceSaveTitle => 'Nicht standardkonformen Code speichern?';

  @override
  String forceSaveBody(String format) {
    return 'Der Codewert entspricht nicht $format. Du kannst ihn trotzdem speichern – manche Scanner lesen ihn eventuell nicht.';
  }

  @override
  String get forceSaveConfirm => 'Trotzdem speichern';

  @override
  String get addMenuScan => 'Barcode scannen';

  @override
  String get addMenuManual => 'Manuell eingeben';

  @override
  String get scanTitle => 'Code scannen';

  @override
  String get scanHint => 'Code im Rahmen ausrichten';

  @override
  String get scanTorchTooltip => 'Taschenlampe';

  @override
  String get scanPermissionRationale =>
      'OneCode verwendet die Kamera ausschließlich zum Scannen von Codes. Bilder werden nur auf deinem Gerät verarbeitet und weder gespeichert noch hochgeladen.';

  @override
  String get scanPermissionAllow => 'Kamerazugriff erlauben';

  @override
  String get scanPermissionDeniedBody =>
      'Um Codes zu scannen, erlaube bitte den Kamerazugriff in den Systemeinstellungen.';

  @override
  String get scanOpenSettings => 'Einstellungen öffnen';

  @override
  String get scanResultTitle => 'Code erkannt';

  @override
  String get scanUseCode => 'Code verwenden';

  @override
  String get scanRescan => 'Erneut scannen';
}
