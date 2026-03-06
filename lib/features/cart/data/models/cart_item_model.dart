import '../../domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.price,
    required super.quantity,
    super.image,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    // Backend may return _id (MongoDB) or id
    final id = json['_id']?.toString() ?? json['id']?.toString() ?? '';
    // productId may be a nested object or a plain string
    final rawProduct = json['product'];
    final productId = rawProduct is Map
        ? (rawProduct['_id']?.toString() ??
            rawProduct['id']?.toString() ??
            '')
        : (json['productId']?.toString() ?? '');
    final productName = rawProduct is Map
        ? (rawProduct['name'] as String? ??
            json['productName'] as String? ??
            '')
        : (json['productName'] as String? ?? '');
    final price = rawProduct is Map
        ? ((rawProduct['price'] ?? json['price'] ?? 0) as num).toDouble()
        : ((json['price'] ?? 0) as num).toDouble();
    final image = rawProduct is Map
        ? (rawProduct['image'] as String? ?? json['image'] as String?)
        : (json['image'] as String?);

    return CartItemModel(
      id: id,
      productId: productId,
      productName: productName,
      price: price,
      quantity: (json['quantity'] ?? 1) as int,
      image: image,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'image': image,
    };
  }

  @override
  CartItemModel copyWith({
    String? id,
    String? productId,
    String? productName,
    double? price,
    int? quantity,
    String? image,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
    );
  }
}
