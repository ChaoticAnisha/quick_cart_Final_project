import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_cart/features/auth/presentation/state/auth_state.dart';
import 'package:quick_cart/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:quick_cart/features/cart/data/models/cart_item_model.dart';
import 'package:quick_cart/features/cart/presentation/state/cart_state.dart';
import 'package:quick_cart/features/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:quick_cart/features/checkout/presentation/pages/checkout_screen.dart';
import 'package:quick_cart/features/checkout/presentation/state/checkout_state.dart';
import 'package:quick_cart/features/checkout/presentation/viewmodel/checkout_viewmodel.dart';
import 'helpers/test_helpers.dart';

void main() {
  const tItem = CartItemModel(
    id: 'item-1',
    productId: 'prod-1',
    productName: 'Basmati Rice 5kg',
    price: 850,
    quantity: 2,
  );

  List<Override> makeOverrides({
    CartState cartState = const CartState(items: [tItem]),
    CheckoutState checkoutState = const CheckoutState(),
  }) =>
      [
        authViewModelProvider.overrideWith(
          () => FakeAuthViewModel(const AuthState()),
        ),
        cartViewModelProvider.overrideWith(
          (ref) => FakeCartViewModel(cartState),
        ),
        checkoutViewModelProvider.overrideWith(
          (ref) => FakeCheckoutViewModel(checkoutState),
        ),
      ];

  // ── Test 1: Checkout header ──────────────────────────────────────────────
  testWidgets('shows Checkout header title', (tester) async {
    await pumpScreen(tester, const CheckoutScreen(), overrides: makeOverrides());
    await tester.pump();

    expect(find.text('Checkout'), findsOneWidget);
  });

  // ── Test 2: Delivery address form fields ────────────────────────────────
  testWidgets('shows all delivery address form fields', (tester) async {
    await pumpScreen(tester, const CheckoutScreen(), overrides: makeOverrides());
    await tester.pump();

    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Phone Number'), findsOneWidget);
    expect(find.text('Full Address'), findsOneWidget);
    expect(find.text('City'), findsOneWidget);
    expect(find.text('Pincode'), findsOneWidget);
  });

  // ── Test 3: Payment section heading ─────────────────────────────────────
  testWidgets('shows Payment Method section', (tester) async {
    await pumpScreen(tester, const CheckoutScreen(), overrides: makeOverrides());
    await tester.pump();

    expect(find.text('Payment Method'), findsOneWidget);
  });

  // ── Test 4: COD payment option ───────────────────────────────────────────
  testWidgets('shows Cash on Delivery option', (tester) async {
    await pumpScreen(tester, const CheckoutScreen(), overrides: makeOverrides());
    await tester.pump();

    expect(find.text('Cash on Delivery'), findsOneWidget);
  });

  // ── Test 5: Khalti payment option ───────────────────────────────────────
  testWidgets('shows Khalti option', (tester) async {
    await pumpScreen(tester, const CheckoutScreen(), overrides: makeOverrides());
    await tester.pump();

    expect(find.text('Khalti'), findsOneWidget);
  });

  // ── Test 6: Place Order button ──────────────────────────────────────────
  testWidgets('shows Place Order button', (tester) async {
    await pumpScreen(tester, const CheckoutScreen(), overrides: makeOverrides());
    await tester.pump();

    expect(
      find.widgetWithText(ElevatedButton, 'Place Order — ₹1700'),
      findsOneWidget,
    );
  });

  // ── Test 7: Order Summary section ───────────────────────────────────────
  testWidgets('shows Order Summary section with cart item', (tester) async {
    await pumpScreen(tester, const CheckoutScreen(), overrides: makeOverrides());
    await tester.pump();

    expect(find.text('Order Summary'), findsOneWidget);
    expect(find.textContaining('Basmati Rice 5kg'), findsOneWidget);
  });

  // ── Test 8: Form validation shows error on empty submit ──────────────────
  testWidgets('shows Required error when form submitted empty', (tester) async {
    await pumpScreen(tester, const CheckoutScreen(), overrides: makeOverrides());
    await tester.pump();

    // Tap Place Order with empty fields
    await tester.tap(find.byType(ElevatedButton).last);
    await tester.pump();

    expect(find.text('Required'), findsWidgets);
  });

  // ── Test 9: Pick on Map button is visible ────────────────────────────────
  testWidgets('shows Pick on Map button', (tester) async {
    await pumpScreen(tester, const CheckoutScreen(), overrides: makeOverrides());
    await tester.pump();

    expect(find.text('Pick on Map'), findsOneWidget);
  });

  // ── Test 10: Placing order with filled form does not show Required error ──
  testWidgets('filled form does not show Required validation errors',
      (tester) async {
    await pumpScreen(tester, const CheckoutScreen(), overrides: makeOverrides());
    await tester.pump();

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'), 'Aarav Sharma');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Phone Number'), '9800000001');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Address'), 'Thamel, Kathmandu');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'City'), 'Kathmandu');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Pincode'), '44600');
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton).last);
    await tester.pump();

    expect(find.text('Required'), findsNothing);
  });
}
