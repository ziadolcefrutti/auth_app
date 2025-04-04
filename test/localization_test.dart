import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auth__app/core/localization.dart'; // LocalizationService
void main() {
  group('LocalizationService Tests', () {
    test('Load English locale and translate', () async {
      await LocalizationService.load(const Locale('en'));
      expect(LocalizationService.locale.languageCode, 'en');
      expect(LocalizationService.translate('hello'), 'Hello');
      expect(LocalizationService.translate('goodbye'), 'Goodbye');
      expect(LocalizationService.translate('unknownKey'), 'unknownKey');
    });

    test('Load Spanish locale and translate', () async {
      await LocalizationService.load(const Locale('es'));
      expect(LocalizationService.locale.languageCode, 'es');
      expect(LocalizationService.translate('hello'), 'Hola');
      expect(LocalizationService.translate('goodbye'), 'Adiós');
      expect(LocalizationService.translate('unknownKey'), 'unknownKey');
    });

    test('Load Urdu locale and translate', () async {
      await LocalizationService.load(const Locale('ur'));
      expect(LocalizationService.locale.languageCode, 'ur');
      expect(LocalizationService.translate('hello'), 'ہیلو');
      expect(LocalizationService.translate('goodbye'), 'خدا حافظ');
      expect(LocalizationService.translate('unknownKey'), 'unknownKey');
    });

    test('Test fallback for unknown locale', () async {
      await LocalizationService.load(const Locale('es')); // French, not defined
      expect(LocalizationService.translate('hello'), 'Hola');
      expect(LocalizationService.translate('goodbye'), 'Adiós');
      expect(LocalizationService.translate('unknownKey'), 'unknownKey');
    });
  });
}