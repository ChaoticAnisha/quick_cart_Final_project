import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_cart/features/auth/domain/entities/user.dart';
import 'package:quick_cart/features/auth/presentation/state/auth_state.dart';
import 'package:quick_cart/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:quick_cart/features/cart/presentation/state/cart_state.dart';
import 'package:quick_cart/features/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:quick_cart/features/profile/presentation/pages/profile_screen.dart';
import 'helpers/test_helpers.dart';

void main() {
  const tUser = User(
    id: 'user-1',
    name: 'Aarav Sharma',
    email: 'aarav@example.com',
    phone: '9800000001',
    address: 'Lalitpur, Nepal',
  );

  List<Override> makeOverrides({
    AuthState authState = const AuthState(
      status: AuthStatus.authenticated,
      user: tUser,
    ),
  }) =>
      [
        authViewModelProvider.overrideWith(
          () => FakeAuthViewModel(authState),
        ),
        cartViewModelProvider.overrideWith(
          (ref) => FakeCartViewModel(const CartState()),
        ),
      ];

  group('ProfileScreen Widget Tests', () {
    // ── Test 18: shows user name when authenticated ───────────────────────
    testWidgets('shows the logged-in user name', (tester) async {
      await pumpScreen(
        tester,
        const ProfileScreen(),
        overrides: makeOverrides(),
      );
      await tester.pump();

      expect(find.text('Aarav Sharma'), findsWidgets);
    });

    // ── Test 19: shows user email ─────────────────────────────────────────
    testWidgets('shows the logged-in user email', (tester) async {
      await pumpScreen(
        tester,
        const ProfileScreen(),
        overrides: makeOverrides(),
      );
      await tester.pump();

      expect(find.text('aarav@example.com'), findsWidgets);
    });

    // ── Test 20: shows Logout button ─────────────────────────────────────
    testWidgets('shows Logout button', (tester) async {
      await pumpScreen(
        tester,
        const ProfileScreen(),
        overrides: makeOverrides(),
      );
      await tester.pump();

      expect(find.text('Logout'), findsOneWidget);
    });

    // ── Test 21: shows My Orders menu item ───────────────────────────────
    testWidgets('shows My Orders menu item', (tester) async {
      await pumpScreen(
        tester,
        const ProfileScreen(),
        overrides: makeOverrides(),
      );
      await tester.pump();

      expect(find.text('My Orders'), findsWidgets);
    });

    // ── Test 22: shows Personal Information section label ─────────────────
    testWidgets('shows Personal Information section', (tester) async {
      await pumpScreen(
        tester,
        const ProfileScreen(),
        overrides: makeOverrides(),
      );
      await tester.pump();

      expect(find.text('Personal Information'), findsOneWidget);
    });

    // ── Test 23: shows guest prompt when not authenticated ────────────────
    testWidgets('shows sign-in prompt for unauthenticated user', (tester) async {
      await pumpScreen(
        tester,
        const ProfileScreen(),
        overrides: makeOverrides(
          authState: const AuthState(status: AuthStatus.unauthenticated),
        ),
      );
      await tester.pump();

      expect(find.textContaining('sign'), findsWidgets);
    });
  });
}
