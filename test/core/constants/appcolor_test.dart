import 'package:auth_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppColors', () {
    test('AppColors constants have correct values', () {
      // Test for darkGrey color
      expect(AppColors.darkGrey.value, Colors.grey.value);

      // Test for lightGrey color
      expect(AppColors.lightGrey.value, const Color(0xFFEEEEEE).value);

      // Test for primary color
      expect(AppColors.primary.value, const Color(0xFFAED581).value);

      // Test for blue color
      expect(AppColors.blue.value, const Color.fromARGB(255, 45, 145, 227).value);

      // Test for white color
      expect(AppColors.white.value, Colors.white.value);
    });
  });
}
