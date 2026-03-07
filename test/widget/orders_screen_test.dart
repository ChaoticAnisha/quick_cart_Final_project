import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_cart/features/cart/presentation/state/cart_state.dart';
import 'package:quick_cart/features/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:quick_cart/features/orders/domain/entities/order_entity.dart';
import 'package:quick_cart/features/orders/presentation/pages/orders_screen.dart';
import 'package:quick_cart/features/orders/presentation/state/order_state.dart';
import 'package:quick_cart/features/orders/presentation/viewmodel/order_viewmodel.dart';
import 'helpers/test_helpers.dart';

void main() {
  final tOrder = OrderEntity(
    id: 'order-1',
    userId: 'user-1',
    items: const [
      OrderItemEntity(
        productId: 'prod-1',
        productName: 'Dal 1kg',
        price: 120,
        quantity: 2,
      ),
    ],
    totalAmount: 240,
    status: 'Pending',
    deliveryAddress: 'Thamel, Kathmandu',
    paymentMethod: 'COD',
    createdAt: DateTime(2025, 3, 10),
  );

  group('OrdersScreen Widget Tests', () {
    // ── Test 15: shows CircularProgressIndicator when loading ─────────────
    testWidgets('shows loading indicator when orders are loading',
        (tester) async {
      await pumpScreen(
        tester,
        const OrdersScreen(),
        overrides: [
          orderViewModelProvider.overrideWith(
            (ref) => FakeOrderViewModel(
              const OrderState(status: OrderLoadStatus.loading),
            ),
          ),
          cartViewModelProvider.overrideWith(
            (ref) => FakeCartViewModel(const CartState()),
          ),
        ],
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // ── Test 16: shows "No Orders Yet" on empty order list ────────────────
    testWidgets('shows No Orders Yet when order list is empty', (tester) async {
      await pumpScreen(
        tester,
        const OrdersScreen(),
        overrides: [
          orderViewModelProvider.overrideWith(
            (ref) => FakeOrderViewModel(
              const OrderState(
                status: OrderLoadStatus.success,
                orders: [],
              ),
            ),
          ),
          cartViewModelProvider.overrideWith(
            (ref) => FakeCartViewModel(const CartState()),
          ),
        ],
      );
      await tester.pump();
      await tester.pump(); // let microtask complete

      expect(find.text('No Orders Yet'), findsOneWidget);
      expect(find.text('Shop Now'), findsOneWidget);
    });

    // ── Test 17: shows order card when orders exist ───────────────────────
    testWidgets('shows order status badge when orders are loaded',
        (tester) async {
      await pumpScreen(
        tester,
        const OrdersScreen(),
        overrides: [
          orderViewModelProvider.overrideWith(
            (ref) => FakeOrderViewModel(
              OrderState(
                status: OrderLoadStatus.success,
                orders: [tOrder],
              ),
            ),
          ),
          cartViewModelProvider.overrideWith(
            (ref) => FakeCartViewModel(const CartState()),
          ),
        ],
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Pending'), findsOneWidget);
    });

    // ── Test 18: shows order total amount ─────────────────────────────────
    testWidgets('shows order total amount', (tester) async {
      await pumpScreen(
        tester,
        const OrdersScreen(),
        overrides: [
          orderViewModelProvider.overrideWith(
            (ref) => FakeOrderViewModel(
              OrderState(status: OrderLoadStatus.success, orders: [tOrder]),
            ),
          ),
          cartViewModelProvider.overrideWith(
            (ref) => FakeCartViewModel(const CartState()),
          ),
        ],
      );
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('240'), findsWidgets);
    });

    // ── Test 19: shows order payment method ───────────────────────────────
    testWidgets('shows payment method on order card', (tester) async {
      await pumpScreen(
        tester,
        const OrdersScreen(),
        overrides: [
          orderViewModelProvider.overrideWith(
            (ref) => FakeOrderViewModel(
              OrderState(status: OrderLoadStatus.success, orders: [tOrder]),
            ),
          ),
          cartViewModelProvider.overrideWith(
            (ref) => FakeCartViewModel(const CartState()),
          ),
        ],
      );
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('COD'), findsWidgets);
    });

    // ── Test 20: shows orders header title ────────────────────────────────
    testWidgets('shows My Orders header title', (tester) async {
      await pumpScreen(
        tester,
        const OrdersScreen(),
        overrides: [
          orderViewModelProvider.overrideWith(
            (ref) => FakeOrderViewModel(
              const OrderState(status: OrderLoadStatus.success, orders: []),
            ),
          ),
          cartViewModelProvider.overrideWith(
            (ref) => FakeCartViewModel(const CartState()),
          ),
        ],
      );
      await tester.pump();

      expect(find.text('My Orders'), findsOneWidget);
    });
  });
}
