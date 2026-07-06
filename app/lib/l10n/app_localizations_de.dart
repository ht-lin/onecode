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
  String get addMenuGallery => 'Aus Foto erkennen';

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

  @override
  String get imageCaptureTitle => 'Code aus Foto';

  @override
  String get imageNoCodeTitle => 'Kein Code gefunden';

  @override
  String get imageNoCodeBody =>
      'In diesem Bild wurde kein Code erkannt. Möglicherweise ist der Code unscharf, zu klein, abgeschnitten oder das Bild ist zu stark komprimiert. Versuche ein anderes Bild oder gib den Code manuell ein.';

  @override
  String get imagePickAnother => 'Anderes Bild auswählen';

  @override
  String get imageEnterManually => 'Code manuell eingeben';

  @override
  String get imageMultiHint =>
      'Mehrere Codes gefunden. Wähle den Code aus, den du speichern möchtest.';

  @override
  String get searchHint => 'Nach Name oder Notiz suchen';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterExpired => 'Abgelaufen';

  @override
  String get noMatchingCards => 'Keine passenden Karten';

  @override
  String get emptyWalletTitle => 'Noch keine Karten';

  @override
  String get emptyWalletBody =>
      'Füge deine erste Karte hinzu – scanne sie, erkenne sie aus einem Foto oder gib sie manuell ein.';

  @override
  String get emptyWalletAction => 'Erste Karte hinzufügen';

  @override
  String get cardActionFavorite => 'Zu Favoriten hinzufügen';

  @override
  String get cardActionUnfavorite => 'Aus Favoriten entfernen';

  @override
  String get cardActionEdit => 'Bearbeiten';

  @override
  String get cardActionDelete => 'Löschen';

  @override
  String get deleteConfirmTitle => 'Karte löschen?';

  @override
  String deleteConfirmBody(String name) {
    return '„$name“ wird aus deiner Kartensammlung entfernt.';
  }

  @override
  String get displayRotateTooltip => 'Anzeige drehen';

  @override
  String get displayDetailsTooltip => 'Kartendetails';

  @override
  String get notifChannelName => 'Ablauf-Erinnerungen';

  @override
  String get notifChannelDescription =>
      'Erinnerungen, bevor Gutscheine ablaufen';

  @override
  String get notifExpiresSoonTitle => 'Gutschein läuft bald ab';

  @override
  String notifExpiresSoonBody(String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tagen',
      one: 'einem Tag',
    );
    return '$name läuft in $_temp0 ab.';
  }

  @override
  String get notifExpiresTodayTitle => 'Gutschein läuft heute ab';

  @override
  String notifExpiresTodayBody(String name) {
    return '$name ist nur noch heute gültig.';
  }

  @override
  String get settingsAccountSection => 'Konto';

  @override
  String get settingsSignInTitle => 'Anmelden';

  @override
  String get settingsSignInSubtitle =>
      'Karten synchronisieren und mit Freunden teilen';

  @override
  String get settingsSignInComingSoon =>
      'Die Anmeldung kommt in einem späteren Update.';

  @override
  String get settingsGeneralSection => 'Allgemein';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsAppearance => 'Erscheinungsbild';

  @override
  String get settingsAppearanceSystem => 'System';

  @override
  String get settingsAppearanceLight => 'Hell';

  @override
  String get settingsAppearanceDark => 'Dunkel';

  @override
  String get settingsLegalSection => 'Rechtliches';

  @override
  String get legalImpressum => 'Impressum';

  @override
  String get legalPrivacy => 'Datenschutzerklärung';

  @override
  String get legalLicenses => 'Open-Source-Lizenzen';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsRemindersSection => 'Ablauf-Erinnerungen';

  @override
  String get settingsRemindersEnabled => 'Vor Ablauf benachrichtigen';

  @override
  String get settingsRemindersLeadDays => 'Tage im Voraus';

  @override
  String settingsLeadDaysValue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String cleanupPromptBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Gutscheine sind seit über 30 Tagen abgelaufen.',
      one: '1 Gutschein ist seit über 30 Tagen abgelaufen.',
    );
    return '$_temp0';
  }

  @override
  String get cleanupPromptAction => 'Aufräumen';

  @override
  String get cleanupPromptLater => 'Später';

  @override
  String get cleanupConfirmTitle => 'Abgelaufene Gutscheine löschen?';

  @override
  String cleanupConfirmBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count abgelaufene Gutscheine werden aus deiner Kartensammlung entfernt.',
      one: '1 abgelaufener Gutschein wird aus deiner Kartensammlung entfernt.',
    );
    return '$_temp0';
  }
}
