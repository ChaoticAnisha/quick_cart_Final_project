import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/order_state.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/order_usecases.dart';

final orderViewModelProvider =
    StateNotifierProvider<OrderViewModel, OrderState>((ref) {
  return OrderViewModel(
    createOrderUsecase: ref.read(createOrderUsecaseProvider),
    getUserOrdersUsecase: ref.read(getUserOrdersUsecaseProvider),
    getOrderByIdUsecase: ref.read(getOrderByIdUsecaseProvider),
  );
});

class OrderViewModel extends StateNotifier<OrderState> {
  final CreateOrderUsecase _createOrder;
  final GetUserOrdersUsecase _getUserOrders;
  final GetOrderByIdUsecase _getOrderById;

  OrderViewModel({
    required CreateOrderUsecase createOrderUsecase,
    required GetUserOrdersUsecase getUserOrdersUsecase,
    required GetOrderByIdUsecase getOrderByIdUsecase,
  })  : _createOrder = createOrderUsecase,
        _getUserOrders = getUserOrdersUsecase,
        _getOrderById = getOrderByIdUsecase,
        super(const OrderState());

  Future<void> loadOrders() async {
    state = state.copyWith(status: OrderLoadStatus.loading, clearError: true);
    final result = await _getUserOrders();
    result.fold(
      (failure) => state = state.copyWith(
        status: OrderLoadStatus.error,
        errorMessage: failure.message,
      ),
      (orders) => state = state.copyWith(
        status: OrderLoadStatus.success,
        orders: orders,
      ),
    );
  }

  Future<OrderEntity?> placeOrder(CreateOrderParams params) async {
    state = state.copyWith(status: OrderLoadStatus.loading, clearError: true);
    final result = await _createOrder(params);
    return result.fold(
      (failure) {
        state = state.copyWith(
          status: OrderLoadStatus.error,
          errorMessage: failure.message,
        );
        return null;
      },
      (order) {
        state = state.copyWith(
          status: OrderLoadStatus.success,
          currentOrder: order,
          orders: [order, ...state.orders],
        );
        return order;
      },
    );
  }

  Future<void> loadOrderById(String id) async {
    state = state.copyWith(status: OrderLoadStatus.loading, clearError: true);
    final result = await _getOrderById(id);
    result.fold(
      (failure) => state = state.copyWith(
        status: OrderLoadStatus.error,
        errorMessage: failure.message,
      ),
      (order) => state = state.copyWith(
        status: OrderLoadStatus.success,
        currentOrder: order,
      ),
    );
  }

  void clearError() => state = state.copyWith(clearError: true);
}
