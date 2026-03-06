import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api/api_client.dart';
import '../../../../api/api_endpoints.dart';
import '../models/order_model.dart';
import '../../domain/repositories/order_repository.dart';

class OrderRemoteDataSource {
  ApiClient? _apiClient;

  Future<ApiClient> _getClient() async {
    _apiClient ??= ApiClient(await SharedPreferences.getInstance());
    return _apiClient!;
  }

  Future<OrderModel> createOrder(CreateOrderParams params) async {
    final client = await _getClient();
    final response = await client.post(
      ApiEndpoints.orders,
      data: {
        'items': params.items
            .map((i) => {
                  'productId': i.productId,
                  'productName': i.productName,
                  'price': i.price,
                  'quantity': i.quantity,
                  if (i.image != null) 'image': i.image,
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
    final client = await _getClient();
    final response = await client.get(ApiEndpoints.orders);
    final raw = response.data;
    List<dynamic> list = [];
    if (raw is List) {
      list = raw;
    } else if (raw is Map) {
      list = (raw['data']?['orders'] ?? raw['orders'] ?? raw['data'] ?? []) as List;
    }
    return list
        .map((j) => OrderModel.fromJson(j as Map<String, dynamic>))
        .toList();
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
}
