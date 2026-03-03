import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../constants/app_boxes.dart';

/// Local cache backed by Hive for fast offline storage.
class LocalCacheService {
  Box<String> get _productBox => Hive.box<String>(AppBoxes.productBox);
  Box<String> get _categoryBox => Hive.box<String>(AppBoxes.categoryBox);

  static const _keyProducts = 'all_products';
  static const _keyCategories = 'all_categories';

  Future<void> saveProducts(List<Map<String, dynamic>> products) async {
    await _productBox.put(_keyProducts, jsonEncode(products));
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final raw = _productBox.get(_keyProducts);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveCategories(List<Map<String, dynamic>> categories) async {
    await _categoryBox.put(_keyCategories, jsonEncode(categories));
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final raw = _categoryBox.get(_keyCategories);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveCart(List<Map<String, dynamic>> items) async {}
  Future<List<Map<String, dynamic>>> getCart() async => [];
  Future<void> clearCart() async {}
}
