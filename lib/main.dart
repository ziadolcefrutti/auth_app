import 'package:auth_app/core/provdier/langauges_provider.dart';
import 'package:auth_app/core/routers/app_router.dart';
import 'package:auth_app/features/auth/view_model/auth_view_model.dart';
import 'package:auth_app/features/splash/viewmodel/splash_viewmodel.dart';
import 'package:auth_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => LanguagesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguagesProvider>(
      builder:
          (context, value, child) => MaterialApp.router(
            title: 'Auth app',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            locale: value.currentLocale,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: appRouter,
          ),
    );
  }
}
