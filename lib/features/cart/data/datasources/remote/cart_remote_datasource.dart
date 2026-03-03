import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../api/api_client.dart';
import '../../../../../api/api_endpoints.dart';
import '../../../../../core/services/storage/local_cache_service.dart';
import '../../models/cart_item_model.dart';

class CartRemoteDataSource {
  ApiClient? _apiClient;
  final _cache = LocalCacheService();

  Future<ApiClient> _getClient() async {
    _apiClient ??= ApiClient(await SharedPreferences.getInstance());
    return _apiClient!;
  }

  Future<List<CartItemModel>> getCart() async {
    try {
      final client = await _getClient();
      final response = await client.get(ApiEndpoints.cart);
      final raw = response.data;
      final list = _extractList(raw);
      final items = list
          .map((j) => CartItemModel.fromJson(j as Map<String, dynamic>))
          .toList();
      _cache.saveCart(items.map((i) => i.toJson()).toList());
      return items;
    } catch (_) {
      final cached = await _cache.getCart();
      return cached.map((j) => CartItemModel.fromJson(j)).toList();
    }
  }

  Future<CartItemModel?> addItem({
    required String productId,
    required String productName,
    required double price,
    int quantity = 1,
    String? image,
  }) async {
    try {
      final client = await _getClient();
      final response = await client.post(
        ApiEndpoints.cart,
        data: {
          'productId': productId,
          'productName': productName,
          'price': price,
          'quantity': quantity,
          if (image != null) 'image': image,
        },
      );
      final raw = response.data;
      final json = _extractSingle(raw);
      if (json != null) return CartItemModel.fromJson(json);
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<bool> updateQuantity(String productId, int quantity) async {
    try {
      final client = await _getClient();
      await client.put(
        '${ApiEndpoints.cart}/$productId',
        data: {'quantity': quantity},
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> removeItem(String productId) async {
    try {
      final client = await _getClient();
      await client.delete('${ApiEndpoints.cart}/$productId');
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> clearCart() async {
    try {
      final client = await _getClient();
      await client.delete(ApiEndpoints.cart);
      await _cache.clearCart();
      return true;
    } catch (_) {
      await _cache.clearCart();
      return false;
    }
  }

  List<dynamic> _extractList(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) return raw;
    if (raw is Map) {
      for (final key in ['items', 'cart', 'data']) {
        if (raw[key] is List) return raw[key] as List;
      }
      if (raw['data'] is Map) {
        for (final key in ['items', 'cart']) {
          if ((raw['data'] as Map)[key] is List) {
            return (raw['data'] as Map)[key] as List;
          }
        }
      }
    }
    return [];
  }

  Map<String, dynamic>? _extractSingle(dynamic raw) {
    if (raw == null) return null;
    if (raw is Map<String, dynamic>) {
      for (final key in ['item', 'cartItem', 'data']) {
        if (raw[key] is Map<String, dynamic>) return raw[key];
      }
      if (raw.containsKey('productId') || raw.containsKey('_id')) return raw;
    }
    return null;
  }
}
