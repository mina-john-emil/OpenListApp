import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'openlist_native_ui_localizations_en.dart';
import 'openlist_native_ui_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of OpenlistNativeUiLocalizations
/// returned by `OpenlistNativeUiLocalizations.of(context)`.
///
/// Applications need to include `OpenlistNativeUiLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/openlist_native_ui_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: OpenlistNativeUiLocalizations.localizationsDelegates,
///   supportedLocales: OpenlistNativeUiLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the OpenlistNativeUiLocalizations.supportedLocales
/// property.
abstract class OpenlistNativeUiLocalizations {
  OpenlistNativeUiLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static OpenlistNativeUiLocalizations of(BuildContext context) {
    return Localizations.of<OpenlistNativeUiLocalizations>(
      context,
      OpenlistNativeUiLocalizations,
    )!;
  }

  static const LocalizationsDelegate<OpenlistNativeUiLocalizations> delegate =
      _OpenlistNativeUiLocalizationsDelegate();

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
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'CN'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'OpenList'**
  String get app_title;

  /// No description provided for @account_and_safety.
  ///
  /// In en, this message translates to:
  /// **'Account and safety'**
  String get account_and_safety;

  /// No description provided for @mobile_number.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobile_number;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @user_mobile.
  ///
  /// In en, this message translates to:
  /// **'User mobile'**
  String get user_mobile;

  /// No description provided for @user_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get user_email;

  /// No description provided for @modify_password.
  ///
  /// In en, this message translates to:
  /// **'Modify password'**
  String get modify_password;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @modify.
  ///
  /// In en, this message translates to:
  /// **'Modify'**
  String get modify;

  /// No description provided for @please_input_new_value.
  ///
  /// In en, this message translates to:
  /// **'Please input new value'**
  String get please_input_new_value;

  /// No description provided for @new_value.
  ///
  /// In en, this message translates to:
  /// **'New value'**
  String get new_value;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @agree.
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get agree;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacy_policy;

  /// No description provided for @feedback_channels.
  ///
  /// In en, this message translates to:
  /// **'Feedback channels'**
  String get feedback_channels;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @login_failed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get login_failed;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @user_info.
  ///
  /// In en, this message translates to:
  /// **'User info'**
  String get user_info;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'App name:'**
  String get app_name;

  /// No description provided for @package_name.
  ///
  /// In en, this message translates to:
  /// **'Package name:'**
  String get package_name;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version:'**
  String get version;

  /// No description provided for @version_sn.
  ///
  /// In en, this message translates to:
  /// **'Version sn:'**
  String get version_sn;

  /// No description provided for @icp_number.
  ///
  /// In en, this message translates to:
  /// **'ICP number:'**
  String get icp_number;

  /// No description provided for @online_feedback.
  ///
  /// In en, this message translates to:
  /// **'Online feedback'**
  String get online_feedback;

  /// No description provided for @app_info.
  ///
  /// In en, this message translates to:
  /// **'App info'**
  String get app_info;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @port.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get success;

  /// No description provided for @downloadThisFile.
  ///
  /// In en, this message translates to:
  /// **'DownloadThis File'**
  String get downloadThisFile;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied To Clipboard'**
  String get copiedToClipboard;

  /// No description provided for @aListWebLogin.
  ///
  /// In en, this message translates to:
  /// **'OpenList Login'**
  String get aListWebLogin;

  /// No description provided for @storages.
  ///
  /// In en, this message translates to:
  /// **'Storages'**
  String get storages;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @files.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get files;

  /// No description provided for @me.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// No description provided for @addStorage.
  ///
  /// In en, this message translates to:
  /// **'Add Storage'**
  String get addStorage;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @disable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disable;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @docs.
  ///
  /// In en, this message translates to:
  /// **'Docs'**
  String get docs;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;
}

class _OpenlistNativeUiLocalizationsDelegate
    extends LocalizationsDelegate<OpenlistNativeUiLocalizations> {
  const _OpenlistNativeUiLocalizationsDelegate();

  @override
  Future<OpenlistNativeUiLocalizations> load(Locale locale) {
    return SynchronousFuture<OpenlistNativeUiLocalizations>(
      lookupOpenlistNativeUiLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_OpenlistNativeUiLocalizationsDelegate old) => false;
}

OpenlistNativeUiLocalizations lookupOpenlistNativeUiLocalizations(
  Locale locale,
) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return OpenlistNativeUiLocalizationsZhHans();
          case 'Hant':
            return OpenlistNativeUiLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return OpenlistNativeUiLocalizationsZhCn();
          case 'TW':
            return OpenlistNativeUiLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return OpenlistNativeUiLocalizationsEn();
    case 'zh':
      return OpenlistNativeUiLocalizationsZh();
  }

  throw FlutterError(
    'OpenlistNativeUiLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
