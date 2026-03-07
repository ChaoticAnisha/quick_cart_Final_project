import '../../domain/entities/order_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.productId,
    required super.productName,
    required super.price,
    required super.quantity,
    super.image,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final productRaw = json['product'];
    String productId = '';
    String productName = '';
    String? image;

    if (productRaw is Map) {
      productId = productRaw['_id']?.toString() ?? productRaw['id']?.toString() ?? '';
      productName = productRaw['name']?.toString() ?? '';
      image = productRaw['image']?.toString();
    } else {
      productId = json['productId']?.toString() ?? '';
      productName = json['name']?.toString() ?? json['productName']?.toString() ?? '';
      image = json['image']?.toString();
    }

    return OrderItemModel(
      productId: productId,
      productName: productName,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 1,
      image: image,
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'price': price,
    'quantity': quantity,
    if (image != null) 'image': image,
  };
}

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.items,
    required super.totalAmount,
    required super.status,
    required super.deliveryAddress,
    required super.paymentMethod,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List? ?? [];
    final items = rawItems
        .map((i) => OrderItemModel.fromJson(i as Map<String, dynamic>))
        .toList();

    final userRaw = json['user'];
    final userId = userRaw is Map
        ? (userRaw['_id'] ?? userRaw['id']).toString()
        : (json['userId'] ?? json['user'] ?? '').toString();

    return OrderModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      userId: userId,
      items: items,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'pending',
      deliveryAddress: json['deliveryAddress']?.toString() ?? '',
      paymentMethod: json['paymentMethod']?.toString() ?? 'cod',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'items': (items as List<OrderItemModel>).map((i) => i.toJson()).toList(),
    'totalAmount': totalAmount,
    'status': status,
    'deliveryAddress': deliveryAddress,
    'paymentMethod': paymentMethod,
    'createdAt': createdAt.toIso8601String(),
  };
}
