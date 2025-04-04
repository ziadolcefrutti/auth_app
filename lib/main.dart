import 'package:auth__app/firebase_options.dart';
import 'package:auth__app/view_model/langauge_view_model.dart';
import 'package:auth__app/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/localization.dart';
import 'view_model/auth_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => LocalizationViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    LocalizationService.load(const Locale('en'));
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final localizationViewModel = Provider.of<LocalizationViewModel>(context);
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Auth App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const SplashView(),
        // locale: Locale('ur'),
        locale: localizationViewModel.locale,
      );
    });
  }
}
