import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// Application title, shown in the wallet AppBar and task switcher. Brand name, not translated.
  ///
  /// In en, this message translates to:
  /// **'OneCode'**
  String get appTitle;

  /// Bottom navigation label for the card wallet tab
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get tabWallet;

  /// Bottom navigation label for the friends tab
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get tabFriends;

  /// Bottom navigation label for the settings tab
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// Card editor page title when creating a new card
  ///
  /// In en, this message translates to:
  /// **'Add card'**
  String get editorTitleNew;

  /// Card editor page title when editing an existing card
  ///
  /// In en, this message translates to:
  /// **'Edit card'**
  String get editorTitleEdit;

  /// Shown when the edit route points to a deleted or unknown card id
  ///
  /// In en, this message translates to:
  /// **'Card not found'**
  String get editorCardNotFound;

  /// Label of the required card name field, e.g. the store name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldName;

  /// Validation error under the name field when it is empty on save
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get errorNameRequired;

  /// Label of the required raw barcode content field
  ///
  /// In en, this message translates to:
  /// **'Code value'**
  String get fieldCodeValue;

  /// Validation error under the code value field when it is empty on save
  ///
  /// In en, this message translates to:
  /// **'Please enter a code value'**
  String get errorCodeValueRequired;

  /// Label of the barcode format selector (QR Code, EAN-13, …)
  ///
  /// In en, this message translates to:
  /// **'Code type'**
  String get fieldCodeFormat;

  /// Label of the loyalty-card/coupon type selector
  ///
  /// In en, this message translates to:
  /// **'Card type'**
  String get fieldCardKind;

  /// Card type option: loyalty/membership card without expiry
  ///
  /// In en, this message translates to:
  /// **'Loyalty card'**
  String get kindLoyalty;

  /// Card type option: coupon/voucher with optional expiry date
  ///
  /// In en, this message translates to:
  /// **'Coupon'**
  String get kindCoupon;

  /// Label of the coupon expiry date field
  ///
  /// In en, this message translates to:
  /// **'Valid until'**
  String get fieldExpiry;

  /// Placeholder in the expiry field while no date is selected
  ///
  /// In en, this message translates to:
  /// **'No expiry date'**
  String get expiryNotSet;

  /// Tooltip of the clear button next to a selected expiry date
  ///
  /// In en, this message translates to:
  /// **'Remove expiry date'**
  String get removeExpiry;

  /// Label of the optional multi-line note field (PIN hints, conditions, …)
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get fieldNote;

  /// Label above the card face color palette
  ///
  /// In en, this message translates to:
  /// **'Card color'**
  String get fieldColor;

  /// Label of the palette entry and dialog title for picking a custom card color
  ///
  /// In en, this message translates to:
  /// **'Custom color'**
  String get customColor;

  /// Slider label in the custom color dialog
  ///
  /// In en, this message translates to:
  /// **'Hue'**
  String get colorHue;

  /// Slider label in the custom color dialog
  ///
  /// In en, this message translates to:
  /// **'Saturation'**
  String get colorSaturation;

  /// Slider label in the custom color dialog
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get colorBrightness;

  /// Generic save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// Generic cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// Placeholder in the live preview when the code value cannot be rendered in the selected format
  ///
  /// In en, this message translates to:
  /// **'Code preview unavailable'**
  String get previewInvalid;

  /// Warning under the code value field: value uses characters outside the format's character set
  ///
  /// In en, this message translates to:
  /// **'Contains characters not allowed in {format}'**
  String codeIssueCharset(String format);

  /// Warning under the code value field: value has the wrong length for the format
  ///
  /// In en, this message translates to:
  /// **'Length does not match {format}'**
  String codeIssueLength(String format);

  /// Warning under the code value field: the trailing check digit does not match
  ///
  /// In en, this message translates to:
  /// **'Check digit is not valid for {format}'**
  String codeIssueCheckDigit(String format);

  /// Title of the confirmation dialog when saving a code value that fails format validation
  ///
  /// In en, this message translates to:
  /// **'Save non-standard code?'**
  String get forceSaveTitle;

  /// Body of the force-save confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'The code value does not conform to {format}. You can save it anyway — some scanners may not read it.'**
  String forceSaveBody(String format);

  /// Confirm button of the force-save dialog
  ///
  /// In en, this message translates to:
  /// **'Save anyway'**
  String get forceSaveConfirm;

  /// Entry in the wallet '+' menu: open the camera scanner (default capture method)
  ///
  /// In en, this message translates to:
  /// **'Scan barcode'**
  String get addMenuScan;

  /// Entry in the wallet '+' menu: pick an image from the photo library and detect its barcode
  ///
  /// In en, this message translates to:
  /// **'Recognize from photo'**
  String get addMenuGallery;

  /// Entry in the wallet '+' menu: open the blank card editor for manual input
  ///
  /// In en, this message translates to:
  /// **'Enter manually'**
  String get addMenuManual;

  /// App bar title of the camera scanner page
  ///
  /// In en, this message translates to:
  /// **'Scan code'**
  String get scanTitle;

  /// Hint text below the viewfinder frame on the scanner page
  ///
  /// In en, this message translates to:
  /// **'Align the code within the frame'**
  String get scanHint;

  /// Tooltip of the torch toggle button on the scanner page
  ///
  /// In en, this message translates to:
  /// **'Flashlight'**
  String get scanTorchTooltip;

  /// Privacy rationale shown before the first camera permission request
  ///
  /// In en, this message translates to:
  /// **'OneCode uses the camera only to scan barcodes. Images are processed on your device and are never stored or uploaded.'**
  String get scanPermissionRationale;

  /// Button on the rationale pane that triggers the system camera permission dialog
  ///
  /// In en, this message translates to:
  /// **'Allow camera access'**
  String get scanPermissionAllow;

  /// Guidance shown after camera permission was denied; points to the system settings
  ///
  /// In en, this message translates to:
  /// **'To scan codes, please allow camera access in the system settings.'**
  String get scanPermissionDeniedBody;

  /// Button on the denied pane that opens the app's system settings page
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get scanOpenSettings;

  /// Title of the bottom sheet previewing a successfully scanned code
  ///
  /// In en, this message translates to:
  /// **'Code detected'**
  String get scanResultTitle;

  /// Confirm button of the scan preview sheet; continues to the prefilled card editor
  ///
  /// In en, this message translates to:
  /// **'Use code'**
  String get scanUseCode;

  /// Dismiss button of the scan preview sheet; returns to the live viewfinder
  ///
  /// In en, this message translates to:
  /// **'Scan again'**
  String get scanRescan;

  /// App bar title of the photo library barcode recognition page
  ///
  /// In en, this message translates to:
  /// **'Code from photo'**
  String get imageCaptureTitle;

  /// Title of the failure pane when no barcode was detected in the picked image
  ///
  /// In en, this message translates to:
  /// **'No code found'**
  String get imageNoCodeTitle;

  /// Failure pane body: likely causes plus the fallback suggestions (different image, manual input)
  ///
  /// In en, this message translates to:
  /// **'No code was detected in this image. The code may be blurry, too small, cropped, or the image may be heavily compressed. Try a different image or enter the code manually.'**
  String get imageNoCodeBody;

  /// Button on the failure pane that reopens the system photo picker
  ///
  /// In en, this message translates to:
  /// **'Choose another image'**
  String get imagePickAnother;

  /// Fallback button on the failure pane that opens the blank card editor
  ///
  /// In en, this message translates to:
  /// **'Enter code manually'**
  String get imageEnterManually;

  /// Hint above the candidate list when the picked image contains multiple barcodes
  ///
  /// In en, this message translates to:
  /// **'Several codes were found. Select the one you want to save.'**
  String get imageMultiHint;

  /// Placeholder of the wallet search field; matches card names and notes
  ///
  /// In en, this message translates to:
  /// **'Search by name or note'**
  String get searchHint;

  /// Wallet filter chip: show all cards (loyalty card and coupon chips reuse the card type labels)
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// Wallet filter chip for expired coupons; also the badge text on an expired card face
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get filterExpired;

  /// Shown instead of the card grid when search/filter yields no results
  ///
  /// In en, this message translates to:
  /// **'No matching cards'**
  String get noMatchingCards;

  /// Title of the first-use empty state on the wallet page
  ///
  /// In en, this message translates to:
  /// **'No cards yet'**
  String get emptyWalletTitle;

  /// Body of the first-use empty state; names the three capture methods
  ///
  /// In en, this message translates to:
  /// **'Add your first card — scan it, recognize it from a photo, or enter it manually.'**
  String get emptyWalletBody;

  /// Button on the empty state that opens the '+' capture menu
  ///
  /// In en, this message translates to:
  /// **'Add first card'**
  String get emptyWalletAction;

  /// Long-press card action: pin the card to the top of the wallet
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get cardActionFavorite;

  /// Long-press card action: unpin a favorited card
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get cardActionUnfavorite;

  /// Long-press card action: open the card editor
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get cardActionEdit;

  /// Long-press card action and confirm button of the delete dialog
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get cardActionDelete;

  /// Title of the delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete card?'**
  String get deleteConfirmTitle;

  /// Body of the delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" will be removed from your wallet.'**
  String deleteConfirmBody(String name);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
