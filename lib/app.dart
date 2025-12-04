import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/Onboarding_screen.dart';
 import 'screens/login_screen.dart';
 import 'screens/register_screen.dart';
// import 'screens/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
         '/onboarding': (context) => const OnboardingScreen(),
         '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        // '/home': (context) => const HomeScreen(),
      },
    );
  }
}