import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagesProvider with ChangeNotifier {
  Locale _currentLocale = Locale('en');

  Locale get currentLocale => _currentLocale;

  // Constructor to load the saved locale on app startup
  LanguagesProvider() {
    _loadLocale();
  }

  // Set the locale and notify listeners
  Future<void> setLocale(Locale locale) async {
    if (_currentLocale != locale) {
      _currentLocale = locale;
      await _saveLocaleToPrefs(locale);
      notifyListeners();
    }
  }

  // Load saved locale from SharedPreferences
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('locale') ?? 'en'; // Default to 'en'
    _currentLocale = Locale(savedLocale);
    notifyListeners();
  }

  //save local
  Future<void> _saveLocaleToPrefs(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }
}
