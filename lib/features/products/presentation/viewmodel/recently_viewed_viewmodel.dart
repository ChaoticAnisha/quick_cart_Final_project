import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:quick_cart/core/constants/app_boxes.dart';
import 'package:quick_cart/features/products/domain/entities/product.dart';

const _kMaxRecentItems = 10;

final recentlyViewedProvider =
    StateNotifierProvider<RecentlyViewedViewModel, List<Product>>((ref) {
  return RecentlyViewedViewModel();
});

class RecentlyViewedViewModel extends StateNotifier<List<Product>> {
  RecentlyViewedViewModel() : super([]) {
    _load();
  }

  Box<String> get _box => Hive.box<String>(AppBoxes.recentlyViewedBox);

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

  void track(Product product) {
    // Remove if already present (move to front)
    final filtered = state.where((p) => p.id != product.id).toList();
    final updated = [product, ...filtered].take(_kMaxRecentItems).toList();

    // Persist: clear and rewrite in order
    _box.clear();
    for (var i = 0; i < updated.length; i++) {
      _box.put(updated[i].id, jsonEncode(updated[i].toJson()));
    }
    state = updated;
  }
}
