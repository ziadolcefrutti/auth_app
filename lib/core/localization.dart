import 'package:auth__app/localization/en.dart';
import 'package:auth__app/localization/es.dart';
import 'package:auth__app/localization/ur.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LocalizationService {
  static  Locale _locale=const Locale('en');

  static const Map<String, dynamic> _localizations = {
    'en': AppLocalizations.values, // English
    'es': AppEsLocalizations.values, // Spanish
    'ur': AppUrLocalizations.values, // Spanish
  };

  static Locale get locale => _locale;

  static Future<void> load(Locale locale) async {
    _locale = locale;
  }

  static String translate(String key) {
    final localeString = _locale.languageCode;

    if (_localizations.containsKey(localeString)) {
      final localizations = _localizations[localeString];
      return localizations?[key] ?? key;
    }

    return key;
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

// class Localization {
//   static const supportedLocales = [
//     Locale('en'),
//     Locale('es'),
//   ];

//   static const localizationsDelegates = [
//     GlobalMaterialLocalizations.delegate,
//     GlobalWidgetsLocalizations.delegate,
//     GlobalCupertinoLocalizations.delegate,
//   ];
// }
