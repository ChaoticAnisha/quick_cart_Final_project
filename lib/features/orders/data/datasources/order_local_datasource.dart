import 'package:hive/hive.dart';
import '../../../../core/constants/app_boxes.dart';
import '../../domain/entities/order_entity.dart';
import '../models/order_hive_model.dart';

/// Hive-backed local cache for orders — used as offline fallback.
class OrderLocalDataSource {
  Box<OrderHiveModel> get _box =>
      Hive.box<OrderHiveModel>(AppBoxes.orderBox);

  /// Persist a list of orders (replaces previous cache).
  Future<void> cacheOrders(List<OrderEntity> orders) async {
    await _box.clear();
    final entries = {
      for (final o in orders) o.id: OrderHiveModel.fromEntity(o)
    };
    await _box.putAll(entries);
  }

  /// Persist a single order (add or update).
  Future<void> cacheOrder(OrderEntity order) async {
    await _box.put(order.id, OrderHiveModel.fromEntity(order));
  }

  /// Return all cached orders sorted newest-first.
  List<OrderEntity> getCachedOrders() {
    final orders = _box.values.map((h) => h.toEntity()).toList();
    orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return orders;
  }

  /// Return a single cached order, or null if not found.
  OrderEntity? getCachedOrder(String id) {
    final hive = _box.get(id);
    return hive?.toEntity();
  }

  Future<void> clearCache() => _box.clear();
}
