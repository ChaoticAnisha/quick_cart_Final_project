import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:quick_cart/core/constants/app_boxes.dart';
import 'package:quick_cart/features/products/domain/entities/product.dart';

final wishlistViewModelProvider =
    StateNotifierProvider<WishlistViewModel, List<Product>>((ref) {
  return WishlistViewModel();
});

class WishlistViewModel extends StateNotifier<List<Product>> {
  WishlistViewModel() : super([]) {
    _load();
  }

  Box<String> get _box => Hive.box<String>(AppBoxes.wishlistBox);

  void _load() {
    final items = _box.values
        .map((json) {
          try {
            return Product.fromJson(jsonDecode(json) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<Product>()
        .toList();
    state = items;
  }

  bool isWishlisted(String productId) =>
      state.any((p) => p.id == productId);

  void toggle(Product product) {
    if (isWishlisted(product.id)) {
      _remove(product.id);
    } else {
      _add(product);
    }
  }

  void _add(Product product) {
    _box.put(product.id, jsonEncode(product.toJson()));
    state = [product, ...state];
  }

  void _remove(String productId) {
    _box.delete(productId);
    state = state.where((p) => p.id != productId).toList();
  }
}
