import 'package:auth_app/core/provider/langauges_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LanguagesProvider', () {
    test('defaults to English', () async {
      SharedPreferences.setMockInitialValues({}); // simulate empty prefs

      final provider = LanguagesProvider();
      await Future.delayed(Duration.zero); // wait for _loadLocale
      expect(provider.currentLocale.languageCode, 'en');
    });

    test('sets and saves new locale', () async {
      SharedPreferences.setMockInitialValues({});

      final provider = LanguagesProvider();
      await Future.delayed(Duration.zero);

      await provider.setLocale(const Locale('fr'));
      expect(provider.currentLocale.languageCode, 'fr');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('locale'), 'fr');
    });

    test('loads locale from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({'locale': 'ur'});

      final provider = LanguagesProvider();
      await Future.delayed(Duration.zero);

      expect(provider.currentLocale.languageCode, 'ur');
    });
  });
}
