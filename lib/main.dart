import 'package:auth_app/core/provider/langauges_provider.dart';
import 'package:auth_app/core/routes/app_routes.dart';
import 'package:auth_app/core/theme/theme.dart';
import 'package:auth_app/features/auth/app_logic/auth_provider.dart';
import 'package:auth_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:auth_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:auth_app/features/auth/domain/usecase/get_current_user_usecase.dart';
import 'package:auth_app/features/auth/domain/usecase/sign_in_usecase.dart';
import 'package:auth_app/features/auth/domain/usecase/sign_in_with_google_usecase.dart';
import 'package:auth_app/features/auth/domain/usecase/sign_out_usecase.dart';
import 'package:auth_app/features/auth/domain/usecase/sign_up_usecase.dart';
import 'package:auth_app/features/splash/app_logic/splash_provider.dart';
import 'package:auth_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authRemoteDataSource = AuthRemoteDataSourceImpl(
    FirebaseAuth.instance,
    GoogleSignIn(),
  );
  final repo = AuthRepositoryImpl(authRemoteDataSource);
  final signInUseCase = SignInUseCaseImpl(repo);
  final signUpUseCase = SignUpUseCaseImpl(repo);
  final signOutUseCase = SignOutUseCaseImpl(repo);
  final getCurrentUserUseCase = GetCurrentUserUseCaseimpl(repo);
  final signInWithGoogleUseCase = SignInWithGoogleUseCaseImpl(repo);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) =>
                  SplashProvider(getCurrentUserUseCase: getCurrentUserUseCase),
        ),
        ChangeNotifierProvider(
          create:
              (_) => AuthsProvider(
                signInUseCase: signInUseCase,
                signUpUseCase: signUpUseCase,
                signOutUseCase: signOutUseCase,
                getCurrentUserUseCase: getCurrentUserUseCase,
                signInWithGoogleUseCase: signInWithGoogleUseCase,
              ),
        ),
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
            debugShowCheckedModeBanner: false,
            title: 'Auth app',
            theme: lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            locale: value.currentLocale,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: appRouter(initialRoute: RouteNames.splash),
          ),
    );
  }
}
