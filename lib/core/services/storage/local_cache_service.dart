import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight JSON cache backed by SharedPreferences.
/// Used to serve stale data when the API is unreachable (offline fallback).
class LocalCacheService {
  static const _keyProducts = 'cache_products';
  static const _keyCart = 'cache_cart';
  static const _keyCategories = 'cache_categories';

  // ── Products ──────────────────────────────────────────────────────────────

  Future<void> saveProducts(List<Map<String, dynamic>> products) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProducts, jsonEncode(products));
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyProducts);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  // ── Categories ────────────────────────────────────────────────────────────

  Future<void> saveCategories(List<Map<String, dynamic>> categories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCategories, jsonEncode(categories));
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyCategories);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  // ── Cart ──────────────────────────────────────────────────────────────────

  Future<void> saveCart(List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCart, jsonEncode(items));
  }

  Future<List<Map<String, dynamic>>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyCart);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCart);
  }
}
