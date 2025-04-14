import 'package:auth_app/features/home/view/widgets/langauge_selection_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:auth_app/core/provdier/langauges_provider.dart';

class LanguageSelectPage extends StatelessWidget {
  const LanguageSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguagesProvider>(context);
    final currentLocale = languageProvider.currentLocale;

    // Function to change the language
    void onLanguageSelected(Locale locale) {
      languageProvider.setLocale(locale);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(AppLocalizations.of(context)?.selectLangauge ?? ''),
      ),
      body: ListView(
        children: [
          LanguageSelectionTile(
            languageName: 'English',
            locale: Locale('en'),
            currentLocale: currentLocale,
            onLanguageSelected: onLanguageSelected,
          ),
          LanguageSelectionTile(
            languageName: 'Spanish',
            locale: Locale('es'),
            currentLocale: currentLocale,
            onLanguageSelected: onLanguageSelected,
          ),
          LanguageSelectionTile(
            languageName: 'Urdu',
            locale: Locale('ur'),
            currentLocale: currentLocale,
            onLanguageSelected: onLanguageSelected,
          ),
          // Add more languages here if needed
        ],
      ),
    );
  }
}
