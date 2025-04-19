import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagesProvider with ChangeNotifier {
  Locale _currentLocale = Locale('en');

  Locale get currentLocale => _currentLocale;

  LanguagesProvider() {
    _loadLocale();
  }

  Future<void> setLocale(Locale locale) async {
    if (_currentLocale != locale) {
      _currentLocale = locale;
      await _saveLocaleToPrefs(locale);
      notifyListeners();
    }
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('locale') ?? 'en'; // Default to 'en'
    _currentLocale = Locale(savedLocale);
    notifyListeners();
  }

  Future<void> _saveLocaleToPrefs(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }
}
