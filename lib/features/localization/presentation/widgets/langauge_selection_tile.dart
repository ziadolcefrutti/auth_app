import 'package:flutter/material.dart';

class LanguageSelectionTile extends StatelessWidget {
  final String languageName;
  final Locale locale;
  final Locale currentLocale;
  final Function(Locale) onLanguageSelected;

  const LanguageSelectionTile({
    required this.languageName,
    required this.locale,
    required this.currentLocale,
    required this.onLanguageSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(languageName),
      trailing: Radio<Locale>(
        value: locale,
        groupValue: currentLocale,
        onChanged: (Locale? value) {
          if (value != null) {
            onLanguageSelected(value);
          }
        },
      ),
      onTap: () => onLanguageSelected(locale),
    );
  }
}
