import 'package:hive_flutter/hive_flutter.dart';
import '../../models/cart_item_model.dart';
import '../../../../../core/constants/app_boxes.dart';

class CartLocalDataSource {
  Future<void> addItem(CartItemModel item) async {
    final box = await Hive.openBox<Map>(AppBoxes.cartBox);
    await box.put(item.productId, {
      'id': item.id,
      'productId': item.productId,
      'productName': item.productName,
      'price': item.price,
      'quantity': item.quantity,
      'image': item.image,
    });
  }

  Future<void> removeItem(String productId) async {
    final box = await Hive.openBox<Map>(AppBoxes.cartBox);
    await box.delete(productId);
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    final box = await Hive.openBox<Map>(AppBoxes.cartBox);
    final item = box.get(productId);
    if (item != null) {
      item['quantity'] = quantity;
      await box.put(productId, item);
    }
  }

  Future<List<CartItemModel>> getAllItems() async {
    final box = await Hive.openBox<Map>(AppBoxes.cartBox);
    final items = box.values.toList();
    return items.map((item) {
      return CartItemModel(
        id: item['id'] ?? '',
        productId: item['productId'] ?? '',
        productName: item['productName'] ?? '',
        price: (item['price'] ?? 0).toDouble(),
        quantity: item['quantity'] ?? 1,
        image: item['image'],
      );
    }).toList();
  }

  Future<void> clearCart() async {
    final box = await Hive.openBox<Map>(AppBoxes.cartBox);
    await box.clear();
  }

  Future<CartItemModel?> getItem(String productId) async {
    final box = await Hive.openBox<Map>(AppBoxes.cartBox);
    final item = box.get(productId);
    if (item != null) {
      return CartItemModel(
        id: item['id'] ?? '',
        productId: item['productId'] ?? '',
        productName: item['productName'] ?? '',
        price: (item['price'] ?? 0).toDouble(),
        quantity: item['quantity'] ?? 1,
        image: item['image'],
      );
    }
    return null;
  }
}
