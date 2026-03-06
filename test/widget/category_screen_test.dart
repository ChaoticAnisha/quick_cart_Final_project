import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_cart/features/cart/presentation/state/cart_state.dart';
import 'package:quick_cart/features/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:quick_cart/features/products/domain/entities/product.dart';
import 'package:quick_cart/features/products/presentation/state/product_state.dart';
import 'package:quick_cart/features/products/presentation/viewmodel/product_viewmodel.dart';
import 'package:quick_cart/features/category/presentation/pages/category_screen.dart';
import 'helpers/test_helpers.dart';

void main() {
  const tProduct1 = Product(
    id: 'p1',
    name: 'Basmati Rice 5kg',
    description: 'Premium quality',
    price: 850,
    stock: 5,
    categoryId: 'cat-1',
    image: '',
  );

  const tProduct2 = Product(
    id: 'p2',
    name: 'Mustard Oil 1L',
    description: 'Cold pressed',
    price: 250,
    stock: 0,
    categoryId: 'cat-2',
    image: '',
  );

  List<Override> makeOverrides({
    ProductState productState = const ProductState(),
  }) =>
      [
        productViewModelProvider.overrideWith(
          (ref) => FakeProductViewModel(productState),
        ),
        cartViewModelProvider.overrideWith(
          (ref) => FakeCartViewModel(const CartState()),
        ),
      ];

  // ── Test 1: Header title ─────────────────────────────────────────────────
  testWidgets('shows All Products header', (tester) async {
    await pumpScreen(
      tester,
      const CategoryScreen(),
      overrides: makeOverrides(),
    );
    await tester.pump();

    expect(find.text('All Products'), findsOneWidget);
  });

  // ── Test 2: Search bar ───────────────────────────────────────────────────
  testWidgets('shows search bar in header', (tester) async {
    await pumpScreen(
      tester,
      const CategoryScreen(),
      overrides: makeOverrides(),
    );
    await tester.pump();

    expect(find.text('Search products...'), findsOneWidget);
  });

  // ── Test 3: Product count label ──────────────────────────────────────────
  testWidgets('shows product count when products loaded', (tester) async {
    await pumpScreen(
      tester,
      const CategoryScreen(),
      overrides: makeOverrides(
        productState: const ProductState(
          products: [tProduct1, tProduct2],
          allProducts: [tProduct1, tProduct2],
        ),
      ),
    );
    await tester.pump();

    expect(find.text('2 Products'), findsOneWidget);
  });

  // ── Test 4: Product names in grid ────────────────────────────────────────
  testWidgets('shows product names in grid', (tester) async {
    await pumpScreen(
      tester,
      const CategoryScreen(),
      overrides: makeOverrides(
        productState: const ProductState(
          products: [tProduct1, tProduct2],
          allProducts: [tProduct1, tProduct2],
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Basmati Rice 5kg'), findsOneWidget);
    expect(find.text('Mustard Oil 1L'), findsOneWidget);
  });

  // ── Test 5: Out of stock overlay ─────────────────────────────────────────
  testWidgets('shows Out of Stock on zero-stock product', (tester) async {
    await pumpScreen(
      tester,
      const CategoryScreen(),
      overrides: makeOverrides(
        productState: const ProductState(
          products: [tProduct2],
          allProducts: [tProduct2],
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Out of Stock'), findsOneWidget);
  });

  // ── Test 6: Empty state ──────────────────────────────────────────────────
  testWidgets('shows No products found when list is empty', (tester) async {
    await pumpScreen(
      tester,
      const CategoryScreen(),
      overrides: makeOverrides(
        productState: const ProductState(products: []),
      ),
    );
    await tester.pump();

    expect(find.text('No products found'), findsOneWidget);
  });

  // ── Test 7: Loading state ─────────────────────────────────────────────────
  testWidgets('shows Loading products text while loading', (tester) async {
    await pumpScreen(
      tester,
      const CategoryScreen(),
      overrides: makeOverrides(
        productState: const ProductState(isLoading: true),
      ),
    );
    await tester.pump();

    expect(find.text('Loading products...'), findsOneWidget);
  });

  // ── Test 8: Bottom navigation bar ────────────────────────────────────────
  testWidgets('shows bottom navigation bar', (tester) async {
    await pumpScreen(
      tester,
      const CategoryScreen(),
      overrides: makeOverrides(),
    );
    await tester.pump();

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Products'), findsOneWidget);
  });
}
