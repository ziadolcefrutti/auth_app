import 'package:auth_app/features/auth/presentation/pages/login_page.dart';
import 'package:auth_app/features/auth/presentation/pages/signup_page.dart';
import 'package:auth_app/features/home/presentation/pages/home_page.dart';
import 'package:auth_app/features/localization/presentation/pages/language_selection_page.dart';
import 'package:auth_app/features/splash/presentation/pages/splash_page.dart';
import 'package:go_router/go_router.dart';

class RouteNames {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String localization = '/language';
}

GoRouter appRouter({required String initialRoute}) {
  return GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.signup,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteNames.localization,
        builder: (context, state) => const LanguageSelectPage(),
      ),
    ],
  );
}
