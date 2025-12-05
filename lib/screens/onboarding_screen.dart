import 'package:flutter/material.dart';

// ==================== ONBOARDING SCREEN 1 ====================
class OnboardingOne extends StatelessWidget {
  const OnboardingOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text('Skip', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const Spacer(),
              Image.asset('assets/images/image 21.png', height: 250),
              const SizedBox(height: 40),
              const Text('Browse Products', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 15),
              const Text('Explore thousands of products\nat your fingertips', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.white70)),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: Colors.white38, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: Colors.white38, shape: BoxShape.circle)),
                ],
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/onboarding2'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFFFFA500), minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                  child: const Text('Next', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== ONBOARDING SCREEN 2 ====================
class OnboardingTwo extends StatelessWidget {
  const OnboardingTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text('Skip', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const Spacer(),
              Image.asset('assets/images/image 22.png', height: 250),
              const SizedBox(height: 40),
              const Text('Easy Checkout', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 15),
              const Text('Quick and secure payment\nprocess for your convenience', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.white70)),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: Colors.white38, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: Colors.white38, shape: BoxShape.circle)),
                ],
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/onboarding3'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFFFFA500), minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                  child: const Text('Next', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== ONBOARDING SCREEN 3 ====================
class OnboardingThree extends StatelessWidget {
  const OnboardingThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text('Skip', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const Spacer(),
              Image.asset('assets/images/image 23.png', height: 250),
              const SizedBox(height: 40),
              const Text('Fast Delivery', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 15),
              const Text('Get your orders delivered\nquickly to your doorstep', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.white70)),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: Colors.white38, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: Colors.white38, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                ],
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFFFFA500), minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                  child: const Text('Get Started', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}