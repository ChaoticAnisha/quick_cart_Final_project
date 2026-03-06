import 'package:flutter_test/flutter_test.dart';
import 'package:quick_cart/features/cart/data/models/cart_item_model.dart';
import 'package:quick_cart/features/cart/presentation/state/cart_state.dart';
import 'package:quick_cart/features/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:quick_cart/features/cart/presentation/pages/cart_screen.dart';
import 'helpers/test_helpers.dart';

void main() {
  group('CartScreen Widget Tests', () {
    // ── Test 8: shows "Cart is Empty" when no items ───────────────────────
    testWidgets('shows empty cart text when cart has no items', (tester) async {
      await pumpScreen(
        tester,
        const CartScreen(),
        overrides: [
          cartViewModelProvider.overrideWith(
            (ref) => FakeCartViewModel(const CartState()),
          ),
        ],
      );
      await tester.pump(); // let loadCart() run

      expect(find.text('Cart is Empty'), findsOneWidget);
    });

    // ── Test 9: shows "Browse Products" button on empty cart ──────────────
    testWidgets('shows Browse Products button on empty cart', (tester) async {
      await pumpScreen(
        tester,
        const CartScreen(),
        overrides: [
          cartViewModelProvider.overrideWith(
            (ref) => FakeCartViewModel(const CartState()),
          ),
        ],
      );
      await tester.pump();

      expect(find.text('Browse Products'), findsOneWidget);
    });

    // ── Test 10: shows product name when cart has items ───────────────────
    testWidgets('shows product name when cart has one item', (tester) async {
      const item = CartItemModel(
        id: 'item-1',
        productId: 'prod-1',
        productName: 'Basmati Rice 5kg',
        price: 850,
        quantity: 1,
      );
      await pumpScreen(
        tester,
        const CartScreen(),
        overrides: [
          cartViewModelProvider.overrideWith(
            (ref) => FakeCartViewModel(
              const CartState(items: [item]),
            ),
          ),
        ],
      );
      await tester.pump();

      expect(find.text('Basmati Rice 5kg'), findsOneWidget);
    });

    // ── Test 11: shows "Proceed to Checkout" when items exist ────────────
    testWidgets('shows Proceed to Checkout button when cart has items',
        (tester) async {
      const item = CartItemModel(
        id: 'item-2',
        productId: 'prod-2',
        productName: 'Mustard Oil 1L',
        price: 300,
        quantity: 2,
      );
      await pumpScreen(
        tester,
        const CartScreen(),
        overrides: [
          cartViewModelProvider.overrideWith(
            (ref) => FakeCartViewModel(
              const CartState(items: [item]),
            ),
          ),
        ],
      );
      await tester.pump();

      expect(find.text('Proceed to Checkout'), findsOneWidget);
    });
  });
}
