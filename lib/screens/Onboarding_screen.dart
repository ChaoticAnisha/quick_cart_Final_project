import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: const [
          Center(child: Text('Onboarding 1')),
          Center(child: Text('Onboarding 2')),
          Center(child: Text('Onboarding 3')),
        ],
      ),
    );
  }
}