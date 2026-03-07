import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api/api_client.dart';
import '../../../../api/api_endpoints.dart';
import '../../../../core/constants/app_boxes.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/order_hive_model.dart';
import '../models/order_model.dart';
import '../../domain/repositories/order_repository.dart';

class OrderRemoteDataSource {
  ApiClient? _apiClient;

  Future<(ApiClient, String)> _getClientAndUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(AppConstants.keyUserId) ?? '';
    _apiClient ??= ApiClient(prefs);
    return (_apiClient!, userId);
  }

  Future<ApiClient> _getClient() async {
    _apiClient ??= ApiClient(await SharedPreferences.getInstance());
    return _apiClient!;
  }

  Future<OrderModel> createOrder(CreateOrderParams params) async {
    final client = await _getClient();
    final response = await client.post(
      ApiEndpoints.orders,
      data: {
        'userId': params.userId,
        'items': params.items
            .map((i) => {
                  'productId': i.productId,
                  'name': i.productName,
                  'price': i.price,
                  'quantity': i.quantity,
                  'image': i.image ?? '',
                })
            .toList(),
        'totalAmount': params.totalAmount,
        'deliveryAddress': params.deliveryAddress,
        'paymentMethod': params.paymentMethod,
      },
    );
    final raw = response.data;
    final json = (raw is Map && raw.containsKey('data'))
        ? (raw['data']['order'] ?? raw['data'] ?? raw)
        : (raw is Map && raw.containsKey('order'))
            ? raw['order']
            : raw;
    return OrderModel.fromJson(json as Map<String, dynamic>);
  }

  Future<List<OrderModel>> getUserOrders() async {
    final box = Hive.box<OrderHiveModel>(AppBoxes.orderBox);
    try {
      final (client, userId) = await _getClientAndUserId();
      final response = await client.get('${ApiEndpoints.orders}/user/$userId');
      final raw = response.data;
      List<dynamic> list = [];
      if (raw is List) {
        list = raw;
      } else if (raw is Map) {
        final data = raw['data'];
        if (data is List) {
          list = data;
        } else if (data is Map) {
          list = (data['orders'] ?? []) as List;
        } else {
          list = (raw['orders'] ?? []) as List;
        }
      }
      final orders = list
          .map((j) => OrderModel.fromJson(j as Map<String, dynamic>))
          .toList();
      // Persist to Hive for offline access
      await box.clear();
      for (final order in orders) {
        await box.put(order.id, OrderHiveModel.fromEntity(order));
      }
      return orders;
    } catch (_) {
      // Offline fallback — return cached orders from Hive
      return box.values.map((h) => OrderModel.fromJson({
        'id': h.id,
        '_id': h.id,
        'userId': h.userId,
        'totalAmount': h.totalAmount,
        'status': h.status,
        'deliveryAddress': h.deliveryAddress,
        'paymentMethod': h.paymentMethod,
        'createdAt': h.createdAt,
        'items': h.items,
      })).toList();
    }
  }

  Future<OrderModel> getOrderById(String id) async {
    final client = await _getClient();
    final response = await client.get('${ApiEndpoints.orders}/$id');
    final raw = response.data;
    final json = (raw is Map)
        ? (raw['data']?['order'] ?? raw['order'] ?? raw['data'] ?? raw)
        : raw;
    return OrderModel.fromJson(json as Map<String, dynamic>);
  }

  Future<OrderModel> cancelOrder(String id) async {
    final client = await _getClient();
    final response = await client.patch(
      ApiEndpoints.cancelOrder(id),
      data: {'status': 'cancelled'},
    );
    final raw = response.data;
    final json = (raw is Map)
        ? (raw['data']?['order'] ?? raw['order'] ?? raw['data'] ?? raw)
        : raw;
    return OrderModel.fromJson(json as Map<String, dynamic>);
  }
}
