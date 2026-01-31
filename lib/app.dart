import 'package:flutter/material.dart';
import 'core/constants/app_routes.dart';
import 'features/splash/presentation/pages/splash_screen.dart';
import 'features/onboarding/presentation/pages/onboarding_screen.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/register_screen.dart';
import 'features/dashboard/presentation/pages/dashboard_screen.dart';
import 'features/category/presentation/pages/category_screen.dart';
import 'features/cart/presentation/pages/cart_screen.dart';
import 'features/profile/presentation/profile_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuickCart',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.onboarding1: (context) => const OnboardingOne(),
        AppRoutes.onboarding2: (context) => const OnboardingTwo(),
        AppRoutes.onboarding3: (context) => const OnboardingThree(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.home: (context) => const DashboardScreen(),
        AppRoutes.dashboard: (context) => const DashboardScreen(),
        AppRoutes.category: (context) => CategoryScreen(),
        AppRoutes.cart: (context) => CartScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
      },
    );
  }
}
