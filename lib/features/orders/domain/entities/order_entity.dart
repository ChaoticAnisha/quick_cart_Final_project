import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? image;

  const OrderItemEntity({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.image,
  });

  double get subtotal => price * quantity;

  @override
  List<Object?> get props => [productId, productName, price, quantity, image];
}

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final List<OrderItemEntity> items;
  final double totalAmount;
  final String status;
  final String deliveryAddress;
  final String paymentMethod;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, items, totalAmount, status, deliveryAddress, paymentMethod, createdAt];
}
