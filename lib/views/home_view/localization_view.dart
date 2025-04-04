import 'package:auth__app/view_model/langauge_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // For ChangeNotifierProvider
import 'package:auth__app/core/localization.dart';

class LocalizationView extends StatelessWidget {
  const LocalizationView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationViewModel = Provider.of<LocalizationViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationService.translate('welcome')),
      ),
      body: Center(
        child: DropdownButton<Locale>(
          value: localizationViewModel.locale,
          onChanged: (Locale? newLocale) {
            if (newLocale != null) {
              localizationViewModel.changeLanguage(newLocale);
            }
          },
          items: const [
            DropdownMenuItem(
              value: Locale('en'),
              child: Text('English'),
            ),
            DropdownMenuItem(
              value: Locale('es'),
              child: Text('Spanish'),
            ),
            DropdownMenuItem(
              value: Locale('ur'),
              child: Text('Urdu'),
            ),
          ],
        ),
      ),
    );
  }
}
