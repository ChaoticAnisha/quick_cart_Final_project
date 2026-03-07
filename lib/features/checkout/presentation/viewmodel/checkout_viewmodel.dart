import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/checkout_state.dart';
import '../../../auth/presentation/viewmodel/auth_viewmodel.dart';
import '../../../cart/presentation/viewmodel/cart_viewmodel.dart';
import '../../../orders/presentation/viewmodel/order_viewmodel.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/domain/repositories/order_repository.dart';

final checkoutViewModelProvider =
    StateNotifierProvider.autoDispose<CheckoutViewModel, CheckoutState>(
  (ref) => CheckoutViewModel(ref),
);

class CheckoutViewModel extends StateNotifier<CheckoutState> {
  final Ref _ref;

  CheckoutViewModel(this._ref) : super(const CheckoutState());

  /// Switch between 'cod' and 'khalti'.
  void selectPayment(String method) {
    state = state.copyWith(selectedPayment: method);
  }

  /// Build delivery address string, validate cart, call order usecase.
  /// Returns the placed [OrderEntity] on success, null on failure.
  Future<OrderEntity?> placeOrder({required String deliveryAddress}) async {
    final cartState = _ref.read(cartViewModelProvider);
    if (cartState.items.isEmpty) {
      state = state.copyWith(
        status: CheckoutStatus.error,
        errorMessage: 'Cart is empty',
      );
      return null;
    }

    state = state.copyWith(status: CheckoutStatus.placing, clearError: true);

    final total = _ref.read(cartViewModelProvider.notifier).totalAmount;

    final items = cartState.items
        .map(
          (item) => OrderItemEntity(
            productId: item.productId,
            productName: item.productName,
            price: item.price,
            quantity: item.quantity,
            image: item.image,
          ),
        )
        .toList();

    final userId = _ref.read(authViewModelProvider).user?.id ?? '';

    final params = CreateOrderParams(
      userId: userId,
      items: items,
      totalAmount: total,
      deliveryAddress: deliveryAddress,
      paymentMethod: state.selectedPayment,
    );

    final order =
        await _ref.read(orderViewModelProvider.notifier).placeOrder(params);

    if (order != null) {
      state = state.copyWith(status: CheckoutStatus.success, clearError: true);
      _ref.read(cartViewModelProvider.notifier).clearCart();
    } else {
      final msg = _ref.read(orderViewModelProvider).errorMessage ??
          'Failed to place order';
      state = state.copyWith(
        status: CheckoutStatus.error,
        errorMessage: msg,
      );
    }

    return order;
  }

  void clearError() => state = state.copyWith(clearError: true);
}
