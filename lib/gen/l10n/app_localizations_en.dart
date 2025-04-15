// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TickMate';

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String get unknown => 'Unknown state';

  @override
  String get retry => 'Retry';

  @override
  String get ok => 'OK';

  @override
  String get errorServerMessage => 'An error occurred while communicating with the server.';

  @override
  String get errorNetworkMessage => 'There is a problem with the network connection. Please check your internet connection.';

  @override
  String get errorTimeoutMessage => 'No response from the server. Please try again later.';

  @override
  String get errorCacheMessage => 'Failed to load data.';

  @override
  String get errorAuthMessage => 'Authentication failed. Please log in again.';

  @override
  String get errorDefaultMessage => 'An unexpected error occurred.';

  @override
  String get errorLoadingTimers => 'An error occurred while loading timers';

  @override
  String get errorCreatingTimer => 'An error occurred while creating timer';

  @override
  String get errorDeletingTimer => 'An error occurred while deleting timer';

  @override
  String get loading => 'Loading...';

  @override
  String get loadingCharacter => 'Loading character information...';

  @override
  String get noTimers => 'No timers. Please add one.';

  @override
  String get addTimer => 'Add timer';

  @override
  String get settings => 'Settings';

  @override
  String get geminiApiKeySettings => 'Gemini API Key Settings';

  @override
  String get geminiApiKeyDescription => 'Please enter your Google Gemini API key. The API key will be stored in the device\'s secure storage and will only be used within the app.';

  @override
  String get geminiApiKey => 'Gemini API key';

  @override
  String get enterApiKey => 'Enter API key';

  @override
  String get saveApiKey => 'Save API key';

  @override
  String get deleteApiKey => 'Delete API key';

  @override
  String get connectionTest => 'Connection test';

  @override
  String get testSuccess => 'Test successful';

  @override
  String get testFailure => 'Test failed';

  @override
  String get selectFromGallery => 'Select from gallery';

  @override
  String createdAt(String date) {
    return 'Created: $date';
  }

  @override
  String updatedAt(String date) {
    return 'Updated: $date';
  }

  @override
  String errorLoadingWorkList(String message) {
    return 'Failed to load work list: $message';
  }

  @override
  String get apiKeyNotSet => 'Gemini API key is not set';

  @override
  String get timerTab => 'Timer';

  @override
  String get notificationTab => 'Notifications';

  @override
  String get characterTab => 'Character';

  @override
  String get settingsTab => 'Settings';

  @override
  String get workList => 'Work List';

  @override
  String get noWorks => 'No works available.';

  @override
  String get workListScreen => 'Work List Screen';

  @override
  String get workInfo => 'Work Information:';

  @override
  String get characterList => 'Character List:';

  @override
  String get noCharactersInWork => 'No characters in this work.';

  @override
  String get workDetailScreen => 'Work Detail Screen';

  @override
  String get promptLabel => 'Prompt:';

  @override
  String get sampleTimer => 'Sample Timer';

  @override
  String get selectDate => 'Select Date';

  @override
  String get selectTime => 'Select Time';

  @override
  String get dateTimePickerTitle => 'Select Date and Time';

  @override
  String get dateTimePickerConfirm => 'Confirm';

  @override
  String get dateTimePickerCancel => 'Cancel';

  @override
  String get timeSpecificationTypeLabel => 'Time Specification Type';

  @override
  String get timeSpecTypeDateTime => 'Set Date/Time';

  @override
  String get timeSpecTypeSpecificTime => 'Specific Time Only';

  @override
  String get timeSpecTypeTimeRange => 'Specific Time Range';

  @override
  String get timePickerLabelFrom => 'From';

  @override
  String get timePickerLabelTo => 'To';

  @override
  String get timePickerLabel => 'Time';

  @override
  String get timerCreatedSuccessfully => 'Timer created successfully';
}
