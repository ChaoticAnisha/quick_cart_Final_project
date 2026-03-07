import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_cart/features/auth/domain/entities/user.dart';
import 'package:quick_cart/features/auth/presentation/state/auth_state.dart';
import 'package:quick_cart/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:quick_cart/features/cart/presentation/state/cart_state.dart';
import 'package:quick_cart/features/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:quick_cart/features/products/domain/entities/product.dart';
import 'package:quick_cart/features/products/presentation/state/product_state.dart';
import 'package:quick_cart/features/products/presentation/viewmodel/product_viewmodel.dart';
import 'package:quick_cart/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:quick_cart/features/products/presentation/viewmodel/recently_viewed_viewmodel.dart';
import 'package:quick_cart/features/wishlist/presentation/viewmodel/wishlist_viewmodel.dart';
import 'helpers/test_helpers.dart';

void main() {
  const tUser = User(
    id: 'u1',
    name: 'Priya Thapa',
    email: 'priya@example.com',
    phone: '9800000002',
    address: 'Kathmandu',
  );

  const tProduct = Product(
    id: 'p1',
    name: 'Mustard Oil 1L',
    description: 'Pure cold-pressed',
    price: 250,
    stock: 10,
    categoryId: 'cat-1',
    image: '',
  );

  List<Override> makeOverrides({
    AuthState authState = const AuthState(
      status: AuthStatus.authenticated,
      user: tUser,
    ),
    ProductState productState = const ProductState(),
    CartState cartState = const CartState(),
  }) =>
      [
        authViewModelProvider.overrideWith(
          () => FakeAuthViewModel(authState),
        ),
        cartViewModelProvider.overrideWith(
          (ref) => FakeCartViewModel(cartState),
        ),
        productViewModelProvider.overrideWith(
          (ref) => FakeProductViewModel(productState),
        ),
        wishlistViewModelProvider.overrideWith(
          (ref) => FakeWishlistViewModel(),
        ),
        recentlyViewedProvider.overrideWith(
          (ref) => FakeRecentlyViewedViewModel(),
        ),
      ];

  // ── Test 1: Greets user ──────────────────────────────────────────────────
  testWidgets('shows Welcome back and user name', (tester) async {
    await pumpScreen(
      tester,
      const DashboardScreen(),
      overrides: makeOverrides(),
    );
    await tester.pump();

    expect(find.text('Welcome back,'), findsOneWidget);
    expect(find.text('Priya Thapa'), findsOneWidget);
  });

  // ── Test 2: Search bar ───────────────────────────────────────────────────
  testWidgets('shows search bar with hint text', (tester) async {
    await pumpScreen(
      tester,
      const DashboardScreen(),
      overrides: makeOverrides(),
    );
    await tester.pump();

    expect(find.text('Search products...'), findsOneWidget);
  });

  // ── Test 3: Category section ─────────────────────────────────────────────
  testWidgets('shows Shop by Category section', (tester) async {
    await pumpScreen(
      tester,
      const DashboardScreen(),
      overrides: makeOverrides(),
    );
    await tester.pump();

    expect(find.text('Shop by Category'), findsOneWidget);
  });

  // ── Test 4: Popular products section header ──────────────────────────────
  testWidgets('shows Popular Products section', (tester) async {
    await pumpScreen(
      tester,
      const DashboardScreen(),
      overrides: makeOverrides(),
    );
    await tester.pump();

    expect(find.text('Popular Products'), findsOneWidget);
  });

  // ── Test 5: Loading state ────────────────────────────────────────────────
  testWidgets('shows CircularProgressIndicator when products loading',
      (tester) async {
    await pumpScreen(
      tester,
      const DashboardScreen(),
      overrides: makeOverrides(
        productState: const ProductState(isLoading: true),
      ),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  // ── Test 6: Empty state ──────────────────────────────────────────────────
  testWidgets('shows no products message when list is empty', (tester) async {
    await pumpScreen(
      tester,
      const DashboardScreen(),
      overrides: makeOverrides(
        productState: const ProductState(isLoading: false),
      ),
    );
    await tester.pump();

    expect(find.text('No products available'), findsOneWidget);
  });

  // ── Test 7: Product name visible ─────────────────────────────────────────
  testWidgets('shows product name when products loaded', (tester) async {
    await pumpScreen(
      tester,
      const DashboardScreen(),
      overrides: makeOverrides(
        productState: const ProductState(
          products: [tProduct],
          allProducts: [tProduct],
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Mustard Oil 1L'), findsOneWidget);
  });

  // ── Test 8: Bottom navigation bar ────────────────────────────────────────
  testWidgets('shows bottom navigation bar with 4 items', (tester) async {
    await pumpScreen(
      tester,
      const DashboardScreen(),
      overrides: makeOverrides(),
    );
    await tester.pump();

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Cart'), findsAtLeast(1));
  });
}
