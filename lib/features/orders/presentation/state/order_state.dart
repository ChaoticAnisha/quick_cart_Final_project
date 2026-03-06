import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

enum OrderLoadStatus { initial, loading, success, error }

class OrderState extends Equatable {
  final OrderLoadStatus status;
  final List<OrderEntity> orders;
  final OrderEntity? currentOrder;
  final String? errorMessage;

  const OrderState({
    this.status = OrderLoadStatus.initial,
    this.orders = const [],
    this.currentOrder,
    this.errorMessage,
  });

  OrderState copyWith({
    OrderLoadStatus? status,
    List<OrderEntity>? orders,
    OrderEntity? currentOrder,
    String? errorMessage,
    bool clearError = false,
    bool clearCurrent = false,
  }) {
    return OrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      currentOrder: clearCurrent ? null : (currentOrder ?? this.currentOrder),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, orders, currentOrder, errorMessage];
}
