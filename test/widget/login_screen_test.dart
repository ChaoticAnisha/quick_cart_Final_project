import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_cart/features/auth/presentation/state/auth_state.dart';
import 'package:quick_cart/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:quick_cart/features/auth/presentation/pages/login_screen.dart';
import 'helpers/test_helpers.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    // ── Test 1: renders email & password fields ───────────────────────────
    testWidgets('renders email and password hint text', (tester) async {
      await pumpScreen(
        tester,
        const LoginScreen(),
        overrides: [
          authViewModelProvider.overrideWith(
            () => FakeAuthViewModel(const AuthState()),
          ),
        ],
      );

      expect(find.text('Enter your email'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
    });

    // ── Test 2: renders "Welcome Back" title ─────────────────────────────
    testWidgets('renders Welcome Back title', (tester) async {
      await pumpScreen(
        tester,
        const LoginScreen(),
        overrides: [
          authViewModelProvider.overrideWith(
            () => FakeAuthViewModel(const AuthState()),
          ),
        ],
      );

      expect(find.text('Welcome Back'), findsOneWidget);
    });

    // ── Test 3: shows loading indicator when status=loading ───────────────
    testWidgets('shows CircularProgressIndicator when status is loading',
        (tester) async {
      await pumpScreen(
        tester,
        const LoginScreen(),
        overrides: [
          authViewModelProvider.overrideWith(
            () => FakeAuthViewModel(
              const AuthState(status: AuthStatus.loading),
            ),
          ),
        ],
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // ── Test 4: shows "Forgot Password?" link ─────────────────────────────
    testWidgets('shows Forgot Password link', (tester) async {
      await pumpScreen(
        tester,
        const LoginScreen(),
        overrides: [
          authViewModelProvider.overrideWith(
            () => FakeAuthViewModel(const AuthState()),
          ),
        ],
      );

      expect(find.text('Forgot Password?'), findsOneWidget);
    });
  });
}
