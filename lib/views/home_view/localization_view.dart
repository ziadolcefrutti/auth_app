import 'package:auth__app/res/const/app_colors.dart';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 12),
        child: Center(
          child: LocalizationDropDownWidget(localizationViewModel: localizationViewModel),
        ),
      ),
    );
  }
}

class LocalizationDropDownWidget extends StatelessWidget {
  const LocalizationDropDownWidget({
    super.key,
    required this.localizationViewModel,
  });

  final LocalizationViewModel localizationViewModel;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      isExpanded: true,
      elevation: 8,
    borderRadius: BorderRadius.circular(6),
    underline: Container(
      height: 2,
      color: AppColor.primaryColor,  // Border color under the button
    ),
    focusColor: AppColor.lightGrey,
             
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
    );
  }
}
