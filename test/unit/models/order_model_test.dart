import 'package:flutter_test/flutter_test.dart';
import 'package:quick_cart/features/orders/data/models/order_model.dart';

void main() {
  // ── OrderItemModel.fromJson ───────────────────────────────────────────────

  group('OrderItemModel.fromJson', () {
    // Backend returns flat item with `name`
    test('parses name field (backend format)', () {
      final json = {
        'productId': 'prod-1',
        'name': 'Basmati Rice',
        'price': 450,
        'quantity': 2,
      };
      final item = OrderItemModel.fromJson(json);
      expect(item.productName, 'Basmati Rice');
      expect(item.productId, 'prod-1');
      expect(item.price, 450.0);
      expect(item.quantity, 2);
    });

    // Fallback: legacy field `productName`
    test('falls back to productName when name is absent', () {
      final json = {
        'productId': 'prod-2',
        'productName': 'Dal 1kg',
        'price': 120,
        'quantity': 3,
      };
      final item = OrderItemModel.fromJson(json);
      expect(item.productName, 'Dal 1kg');
    });

    // Nested product object (populated reference)
    test('parses nested product object', () {
      final json = {
        'product': {'_id': 'prod-3', 'name': 'Tomato 1kg', 'image': '/img/t.jpg'},
        'price': 60,
        'quantity': 4,
      };
      final item = OrderItemModel.fromJson(json);
      expect(item.productId, 'prod-3');
      expect(item.productName, 'Tomato 1kg');
      expect(item.image, '/img/t.jpg');
    });

    // Missing fields default gracefully
    test('defaults to empty strings when fields are missing', () {
      final item = OrderItemModel.fromJson({'price': 10, 'quantity': 1});
      expect(item.productId, '');
      expect(item.productName, '');
    });
  });

  // ── OrderModel.fromJson ───────────────────────────────────────────────────

  group('OrderModel.fromJson', () {
    final tJson = {
      '_id': 'order-99',
      'userId': 'user-5',
      'items': [
        {'productId': 'p1', 'name': 'Milk 1L', 'price': 80, 'quantity': 2},
      ],
      'totalAmount': 160,
      'status': 'Delivered',
      'deliveryAddress': 'Bhaktapur, Bagmati',
      'paymentMethod': 'Khalti',
      'createdAt': '2025-04-01T10:00:00.000Z',
    };

    test('parses all top-level fields correctly', () {
      final order = OrderModel.fromJson(tJson);
      expect(order.id, 'order-99');
      expect(order.userId, 'user-5');
      expect(order.totalAmount, 160.0);
      expect(order.status, 'Delivered');
      expect(order.deliveryAddress, 'Bhaktapur, Bagmati');
      expect(order.paymentMethod, 'Khalti');
    });

    test('parses items list', () {
      final order = OrderModel.fromJson(tJson);
      expect(order.items.length, 1);
      expect(order.items.first.productName, 'Milk 1L');
      expect(order.items.first.price, 80.0);
    });

    test('parses createdAt as DateTime', () {
      final order = OrderModel.fromJson(tJson);
      expect(order.createdAt.year, 2025);
      expect(order.createdAt.month, 4);
    });

    test('falls back to id when _id is absent', () {
      final json = Map<String, dynamic>.from(tJson);
      json.remove('_id');
      json['id'] = 'order-alt';
      final order = OrderModel.fromJson(json);
      expect(order.id, 'order-alt');
    });

    test('parses userId from nested user object', () {
      final json = Map<String, dynamic>.from(tJson);
      json['user'] = {'_id': 'user-nested'};
      json.remove('userId');
      final order = OrderModel.fromJson(json);
      expect(order.userId, 'user-nested');
    });

    test('toJson round-trips key fields', () {
      final order = OrderModel.fromJson(tJson);
      final out = order.toJson();
      expect(out['id'], 'order-99');
      expect(out['totalAmount'], 160.0);
      expect(out['paymentMethod'], 'Khalti');
    });
  });
}
