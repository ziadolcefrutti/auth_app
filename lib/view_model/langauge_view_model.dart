import 'package:flutter/material.dart';
import 'package:auth__app/core/localization.dart';

class LocalizationViewModel extends ChangeNotifier {
  Locale _locale = const Locale('en'); // Default to English

  Locale get locale => _locale;

  void changeLanguage(Locale newLocale) {
    _locale = newLocale;
    LocalizationService.load(newLocale);
    notifyListeners(); // Notify listeners when the locale changes
  }
}
