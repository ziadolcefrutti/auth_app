import 'package:auth_app/features/auth/view/pages/login_page.dart';
import 'package:auth_app/features/auth/view/pages/signup_page.dart';
import 'package:auth_app/features/home/view/pages/home_page.dart';
import 'package:auth_app/features/home/view/pages/langauge_selection_page.dart';
import 'package:auth_app/features/splash/view/pages/splash_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/language',
      builder: (context, state) => const LanguageSelectPage(),
    ),
  ],
);
