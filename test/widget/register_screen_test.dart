import 'package:flutter_test/flutter_test.dart';
import 'package:quick_cart/features/auth/presentation/state/auth_state.dart';
import 'package:quick_cart/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:quick_cart/features/auth/presentation/pages/register_screen.dart';
import 'helpers/test_helpers.dart';

void main() {
  group('RegisterScreen Widget Tests', () {
    // ── Test 5: renders "Create Account" title ────────────────────────────
    testWidgets('renders Create Account title', (tester) async {
      await pumpScreen(
        tester,
        const RegisterScreen(),
        overrides: [
          authViewModelProvider.overrideWith(
            () => FakeAuthViewModel(const AuthState()),
          ),
        ],
      );

      expect(find.text('Create Account'), findsOneWidget);
    });

    // ── Test 6: renders Sign Up button ────────────────────────────────────
    testWidgets('renders Sign Up button', (tester) async {
      await pumpScreen(
        tester,
        const RegisterScreen(),
        overrides: [
          authViewModelProvider.overrideWith(
            () => FakeAuthViewModel(const AuthState()),
          ),
        ],
      );

      expect(find.text('Sign Up'), findsOneWidget);
    });

    // ── Test 7: shows "Already have an account?" link ─────────────────────
    testWidgets('shows Already have an account link', (tester) async {
      await pumpScreen(
        tester,
        const RegisterScreen(),
        overrides: [
          authViewModelProvider.overrideWith(
            () => FakeAuthViewModel(const AuthState()),
          ),
        ],
      );

      expect(find.text('Already have an account? '), findsOneWidget);
    });
  });
}
