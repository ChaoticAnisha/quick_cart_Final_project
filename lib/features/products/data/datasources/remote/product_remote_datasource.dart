import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../api/api_client.dart';
import '../../../../../api/api_endpoints.dart';
import '../../../../../core/services/storage/local_cache_service.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/entities/category.dart';
import '../../models/product_model.dart';
import '../../models/category_model.dart';

class ProductRemoteDataSource {
  ApiClient? _apiClient;
  final _cache = LocalCacheService();

  Future<ApiClient> _getClient() async {
    _apiClient ??= ApiClient(await SharedPreferences.getInstance());
    return _apiClient!;
  }

  Future<List<Product>> getAllProducts({int page = 1, int limit = 20}) async {
    try {
      final client = await _getClient();
      final response = await client.get(
        ApiEndpoints.getAllProducts,
        queryParameters: {'page': page, 'limit': limit},
      );
      final data = _extractList(response.data, 'products');
      final products = data
          .map((j) => ProductModel.fromJson(j as Map<String, dynamic>))
          .toList();
      // Persist to local cache for offline use
      _cache.saveProducts(products.map((p) => p.toJson()).toList());
      return products;
    } catch (_) {
      // Offline fallback — serve cached products
      final cached = await _cache.getProducts();
      return cached.map((j) => ProductModel.fromJson(j)).toList();
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final client = await _getClient();
      final response = await client.get(
        ApiEndpoints.getAllProducts,
        queryParameters: {'search': query},
      );
      final data = _extractList(response.data, 'products');
      return data.map((j) => ProductModel.fromJson(j as Map<String, dynamic>)).toList();
    } catch (_) {
      // Offline: filter cached products by name
      final cached = await _cache.getProducts();
      final lower = query.toLowerCase();
      return cached
          .map((j) => ProductModel.fromJson(j))
          .where((p) => p.name.toLowerCase().contains(lower))
          .toList();
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      final client = await _getClient();
      final response = await client.get(ApiEndpoints.categories);
      final data = _extractList(response.data, 'categories');
      final categories = data
          .map((j) => CategoryModel.fromJson(j as Map<String, dynamic>))
          .toList();
      _cache.saveCategories(
          categories.map((c) => c.toJson()).toList());
      return categories;
    } catch (_) {
      final cached = await _cache.getCategories();
      return cached.map((j) => CategoryModel.fromJson(j)).toList();
    }
  }

  Future<List<Product>> getProductsByCategory(String categoryId) async {
    try {
      final client = await _getClient();
      final response = await client.get(
        ApiEndpoints.getAllProducts,
        queryParameters: {'category': categoryId},
      );
      final data = _extractList(response.data, 'products');
      return data.map((j) => ProductModel.fromJson(j as Map<String, dynamic>)).toList();
    } catch (_) {
      // Offline: filter cached products by categoryId
      final cached = await _cache.getProducts();
      return cached
          .map((j) => ProductModel.fromJson(j))
          .where((p) => p.categoryId == categoryId)
          .toList();
    }
  }

  Future<Product?> getProductById(String id) async {
    try {
      final client = await _getClient();
      final response = await client.get('${ApiEndpoints.products}/$id');
      final raw = response.data;
      final json = (raw is Map)
          ? (raw['data'] ?? raw['product'] ?? raw)
          : raw;
      return ProductModel.fromJson(json as Map<String, dynamic>);
    } catch (_) {
      // Offline: find in cache
      final cached = await _cache.getProducts();
      return cached
          .map((j) => ProductModel.fromJson(j))
          .cast<Product?>()
          .firstWhere((p) => p?.id == id, orElse: () => null);
    }
  }

  /// Handles `{success, data: {products: [...]}}` and `{products: [...]}` and raw `[...]`
  List<dynamic> _extractList(dynamic raw, String key) {
    if (raw == null) return [];
    if (raw is List) return raw;
    if (raw is Map) {
      if (raw['data'] is Map && (raw['data'] as Map).containsKey(key)) {
        return (raw['data'][key] as List?) ?? [];
      }
      if (raw[key] is List) return raw[key] as List;
      if (raw['data'] is List) return raw['data'] as List;
    }
    return [];
  }
}
