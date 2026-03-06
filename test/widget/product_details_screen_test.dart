import 'package:flutter_test/flutter_test.dart';
import 'package:quick_cart/features/cart/presentation/state/cart_state.dart';
import 'package:quick_cart/features/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:quick_cart/features/products/domain/entities/product.dart';
import 'package:quick_cart/features/products/presentation/pages/product_details_screen.dart';
import 'helpers/test_helpers.dart';

void main() {
  // Shared test product
  const tProduct = Product(
    id: 'prod-1',
    name: 'Organic Honey 500g',
    description: 'Pure organic honey from the Himalayas.',
    price: 750,
    stock: 20,
    categoryId: 'cat-1',
    categoryName: 'Grocery',
    image: '',
    rating: 4.5,
  );

  const tOutOfStockProduct = Product(
    id: 'prod-2',
    name: 'Unavailable Item',
    description: 'This item is out of stock.',
    price: 200,
    stock: 0,
    categoryId: 'cat-2',
    categoryName: 'Snacks',
    image: '',
  );

  group('ProductDetailsScreen Widget Tests', () {
    // ── Test 12: shows product name ───────────────────────────────────────
    testWidgets('shows product name', (tester) async {
      await pumpScreen(
        tester,
        ProductDetailsScreen(product: tProduct),
        overrides: [
          cartViewModelProvider.overrideWith(
            (ref) => FakeCartViewModel(const CartState()),
          ),
        ],
      );
      await tester.pump();

      expect(find.text('Organic Honey 500g'), findsOneWidget);
    });

    // ── Test 13: shows product price ──────────────────────────────────────
    testWidgets('shows formatted product price', (tester) async {
      await pumpScreen(
        tester,
        ProductDetailsScreen(product: tProduct),
        overrides: [
          cartViewModelProvider.overrideWith(
            (ref) => FakeCartViewModel(const CartState()),
          ),
        ],
      );
      await tester.pump();

      // Price appears in both the header and the total line
      expect(find.text('Rs. 750'), findsWidgets);
    });

    // ── Test 14: shows "Out of Stock" button when stock = 0 ──────────────
    testWidgets('shows Out of Stock button when product has no stock',
        (tester) async {
      await pumpScreen(
        tester,
        ProductDetailsScreen(product: tOutOfStockProduct),
        overrides: [
          cartViewModelProvider.overrideWith(
            (ref) => FakeCartViewModel(const CartState()),
          ),
        ],
      );
      await tester.pump();

      // "Out of Stock" appears in both the stock status row and the disabled button
      expect(find.text('Out of Stock'), findsWidgets);
    });
  });
}
