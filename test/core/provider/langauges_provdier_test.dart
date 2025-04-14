import 'package:auth_app/core/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:auth_app/core/provdier/langauges_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LanguagesProvider Test', () {
    setUp(() async {
      // Clear mock storage before each test
      SharedPreferences.setMockInitialValues({});
    });

    test('Default locale is English', () {
      final provider = LanguagesProvider();
      expect(provider.currentLocale, const Locale('en'));
    });

    test('Set and get locale to Urdu', () async {
      final provider = LanguagesProvider();
      await provider.setLocale(const Locale('ur'));

      expect(provider.currentLocale, const Locale('ur'));

      // Check shared prefs stored the value
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('locale'), 'ur');
    });

    test('Loads saved locale from SharedPreferences', () async {
      // Mock saved data before creating provider
      SharedPreferences.setMockInitialValues({'locale': 'ur'});

      final provider = LanguagesProvider();
      // Wait for _loadLocale to complete
      await Future.delayed(Duration(milliseconds: 100));

      expect(provider.currentLocale, const Locale('ur'));
    });
  });
}
