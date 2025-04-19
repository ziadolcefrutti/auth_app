import 'package:flutter/material.dart';
import 'package:auth_app/core/theme/app_pallete.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: AppPallete.primary,
    secondary: AppPallete.secondary,
    tertiary: AppPallete.tertiary,
    surface: AppPallete.white,
    onPrimary: AppPallete.black,
    onSecondary: AppPallete.lightGrey,
    onTertiary: AppPallete.white,
  ),

  scaffoldBackgroundColor: AppPallete.white,

  appBarTheme: const AppBarTheme(
    backgroundColor: AppPallete.primary,
    iconTheme: IconThemeData(color: AppPallete.white),
  ),

  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 18),
    bodyMedium: TextStyle(fontSize: 14),
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  ),

  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(12),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    fillColor: AppPallete.lightGrey,
    filled: true,
  ),

  // Optionally add button, icon, card, etc. themes
);
