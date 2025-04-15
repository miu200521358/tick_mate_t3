import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'TickMate'**
  String get appTitle;

  /// Error message with details
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(String message);

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown state'**
  String get unknown;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @errorServerMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while communicating with the server.'**
  String get errorServerMessage;

  /// No description provided for @errorNetworkMessage.
  ///
  /// In en, this message translates to:
  /// **'There is a problem with the network connection. Please check your internet connection.'**
  String get errorNetworkMessage;

  /// No description provided for @errorTimeoutMessage.
  ///
  /// In en, this message translates to:
  /// **'No response from the server. Please try again later.'**
  String get errorTimeoutMessage;

  /// No description provided for @errorCacheMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data.'**
  String get errorCacheMessage;

  /// No description provided for @errorAuthMessage.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please log in again.'**
  String get errorAuthMessage;

  /// No description provided for @errorDefaultMessage.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get errorDefaultMessage;

  /// No description provided for @errorLoadingTimers.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading timers'**
  String get errorLoadingTimers;

  /// No description provided for @errorCreatingTimer.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while creating timer'**
  String get errorCreatingTimer;

  /// No description provided for @errorDeletingTimer.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while deleting timer'**
  String get errorDeletingTimer;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @loadingCharacter.
  ///
  /// In en, this message translates to:
  /// **'Loading character information...'**
  String get loadingCharacter;

  /// No description provided for @noTimers.
  ///
  /// In en, this message translates to:
  /// **'No timers. Please add one.'**
  String get noTimers;

  /// No description provided for @addTimer.
  ///
  /// In en, this message translates to:
  /// **'Add timer'**
  String get addTimer;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @geminiApiKeySettings.
  ///
  /// In en, this message translates to:
  /// **'Gemini API Key Settings'**
  String get geminiApiKeySettings;

  /// No description provided for @geminiApiKeyDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter your Google Gemini API key. The API key will be stored in the device\'s secure storage and will only be used within the app.'**
  String get geminiApiKeyDescription;

  /// No description provided for @geminiApiKey.
  ///
  /// In en, this message translates to:
  /// **'Gemini API key'**
  String get geminiApiKey;

  /// No description provided for @enterApiKey.
  ///
  /// In en, this message translates to:
  /// **'Enter API key'**
  String get enterApiKey;

  /// No description provided for @saveApiKey.
  ///
  /// In en, this message translates to:
  /// **'Save API key'**
  String get saveApiKey;

  /// No description provided for @deleteApiKey.
  ///
  /// In en, this message translates to:
  /// **'Delete API key'**
  String get deleteApiKey;

  /// No description provided for @connectionTest.
  ///
  /// In en, this message translates to:
  /// **'Connection test'**
  String get connectionTest;

  /// No description provided for @testSuccess.
  ///
  /// In en, this message translates to:
  /// **'Test successful'**
  String get testSuccess;

  /// No description provided for @testFailure.
  ///
  /// In en, this message translates to:
  /// **'Test failed'**
  String get testFailure;

  /// No description provided for @selectFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Select from gallery'**
  String get selectFromGallery;

  /// Created date with value
  ///
  /// In en, this message translates to:
  /// **'Created: {date}'**
  String createdAt(String date);

  /// Updated date with value
  ///
  /// In en, this message translates to:
  /// **'Updated: {date}'**
  String updatedAt(String date);

  /// Error message when loading work list
  ///
  /// In en, this message translates to:
  /// **'Failed to load work list: {message}'**
  String errorLoadingWorkList(String message);

  /// No description provided for @apiKeyNotSet.
  ///
  /// In en, this message translates to:
  /// **'Gemini API key is not set'**
  String get apiKeyNotSet;

  /// No description provided for @timerTab.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timerTab;

  /// No description provided for @notificationTab.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationTab;

  /// No description provided for @characterTab.
  ///
  /// In en, this message translates to:
  /// **'Character'**
  String get characterTab;

  /// No description provided for @settingsTab.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTab;

  /// No description provided for @workList.
  ///
  /// In en, this message translates to:
  /// **'Work List'**
  String get workList;

  /// No description provided for @noWorks.
  ///
  /// In en, this message translates to:
  /// **'No works available.'**
  String get noWorks;

  /// No description provided for @workListScreen.
  ///
  /// In en, this message translates to:
  /// **'Work List Screen'**
  String get workListScreen;

  /// No description provided for @workInfo.
  ///
  /// In en, this message translates to:
  /// **'Work Information:'**
  String get workInfo;

  /// No description provided for @characterList.
  ///
  /// In en, this message translates to:
  /// **'Character List:'**
  String get characterList;

  /// No description provided for @noCharactersInWork.
  ///
  /// In en, this message translates to:
  /// **'No characters in this work.'**
  String get noCharactersInWork;

  /// No description provided for @workDetailScreen.
  ///
  /// In en, this message translates to:
  /// **'Work Detail Screen'**
  String get workDetailScreen;

  /// No description provided for @promptLabel.
  ///
  /// In en, this message translates to:
  /// **'Prompt:'**
  String get promptLabel;

  /// No description provided for @sampleTimer.
  ///
  /// In en, this message translates to:
  /// **'Sample Timer'**
  String get sampleTimer;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// No description provided for @dateTimePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Date and Time'**
  String get dateTimePickerTitle;

  /// No description provided for @dateTimePickerConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get dateTimePickerConfirm;

  /// No description provided for @dateTimePickerCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dateTimePickerCancel;

  /// No description provided for @timeSpecificationTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time Specification Type'**
  String get timeSpecificationTypeLabel;

  /// No description provided for @timeSpecTypeDateTime.
  ///
  /// In en, this message translates to:
  /// **'Set Date/Time'**
  String get timeSpecTypeDateTime;

  /// No description provided for @timeSpecTypeSpecificTime.
  ///
  /// In en, this message translates to:
  /// **'Specific Time Only'**
  String get timeSpecTypeSpecificTime;

  /// No description provided for @timeSpecTypeTimeRange.
  ///
  /// In en, this message translates to:
  /// **'Specific Time Range'**
  String get timeSpecTypeTimeRange;

  /// No description provided for @timePickerLabelFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get timePickerLabelFrom;

  /// No description provided for @timePickerLabelTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get timePickerLabelTo;

  /// No description provided for @timePickerLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timePickerLabel;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ja': return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
