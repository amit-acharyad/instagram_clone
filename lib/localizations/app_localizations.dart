import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
part 'app_en.dart';
part 'app_np.dart';

const Map<String, AppLocalizations> _localizations = {
  'en': _AppLocalizationsEn(),
  'ne': _AppLocalizationsNp(),
};

/// Internal helper extension for localizing strings.
extension AppLocalizationsExtension on BuildContext {
  /// The localization instance.
  AppLocalizations get loc => AppLocalizations.of(this);
}

/// The class to provide localization support for the Khalti Payment Gateway library.
abstract class AppLocalizations {
  /// Default constructor for [AppLocalizations].
  const AppLocalizations();

  /// Returns the localized resources object of [AppLocalizations] for the widget
  /// tree that corresponds to the given [context].
  static AppLocalizations of(BuildContext context) {
    final loc = Localizations.of<AppLocalizations>(
          context,
          AppLocalizations,
        ) ??
        _AppLocalizationsNp();
    return loc;
  }

  /// The delegate to provide [AppLocalizations].
  ///
  /// This should be added to [MaterialApp.localizationsDelegates].
  ///
  /// ```dart
  /// MaterialApp(
  ///   localizationsDelegates: const [
  ///     AppLocalizations.delegate,
  ///     // other delegates
  ///   ],
  /// );
  /// ```
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// An Error Occurred
  String get anErrorOccurred;

  /// No Internet
  String get noInternet;

  /// You are not connected to the internet. Please check your connection.
  String get noInternetMessage;

  /// Network Unreachable
  String get networkUnreachable;

  /// Your connection could not be established.
  String get networkUnreachableMessage;

  /// No Connection
  String get noConnection;

  /// Slow or no internet connection. Please check your internet & try again.
  String get noConnectionMessage;

  /// Please enter a valid mobile number
  String get enterValidMobileNumber;

  /// This field is required
  String get fieldRequired;
  String get comments;
  String get noComments;
  String get chooseTheme;

  // /// Please search for another keyword
  // String get searchForAnotherKeyword;

  /// Confirm Payment

  // /// Reset Khalti MPIN
  // String get resetPassword;

  // /// Cancel
  // String get cancel;

  // /// Ok
  // String get ok;

  String get welcome;
  String get login;
  String get signup;
  String get username;
  String get password;
  String get email;
  String get forgotPassword;
  String get home;
  String get search;
  String get notifications;
  String get profile;
  String get settings;
  String get logout;
  String get post;
  String get posts;
  String get like;
  String get comment;
  String get share;
  String get editProfile;
  String get followers;
  String get following;
  String get message;
  String get messages;
  String get requests;
  String get today;
  String get thisWeek;
  String get language;
  String get theme;
  String get lightTheme;
  String get darkTheme;
  String get systemTheme;
  String get noAccount;
  String get or;
  String get writeAMessage;
  String get send;

  /// Rs. [amount]
  String rupee(double amount) {
    final formattedAmount = NumberFormat.currency(
      symbol: (Intl.defaultLocale ?? 'en').startsWith('ne') ? 'रू.' : 'Rs.',
      customPattern: '\u00A4\u00A0##,##,##0.00',
    ).format(amount);

    if (formattedAmount.endsWith('.00')) {
      return formattedAmount.substring(0, formattedAmount.length - 3);
    }
    return formattedAmount;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture(
      _localizations[locale.languageCode] ?? const _AppLocalizationsEn(),
    );
  }

  @override
  bool isSupported(Locale locale) {
    return _localizations.containsKey(locale.languageCode);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
