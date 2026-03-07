import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order_entity.dart';

class CreateOrderParams {
  final String userId;
  final List<OrderItemEntity> items;
  final double totalAmount;
  final String deliveryAddress;
  final String paymentMethod;

  const CreateOrderParams({
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.paymentMethod,
  });
}

abstract class IOrderRepository {
  Future<Either<Failure, OrderEntity>> createOrder(CreateOrderParams params);
  Future<Either<Failure, List<OrderEntity>>> getUserOrders();
  Future<Either<Failure, OrderEntity>> getOrderById(String id);
  Future<Either<Failure, OrderEntity>> cancelOrder(String id);
}
