import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/products/domain/entities/product.dart';
import '../../../../core/services/storage/local_cache_service.dart';
import '../state/cart_state.dart';
import '../../data/datasources/remote/cart_remote_datasource.dart';
import '../../data/models/cart_item_model.dart';

final cartViewModelProvider = StateNotifierProvider<CartViewModel, CartState>((
  ref,
) {
  return CartViewModel(
    remote: CartRemoteDataSource(),
    cache: LocalCacheService(),
  );
});

class CartViewModel extends StateNotifier<CartState> {
  final CartRemoteDataSource _remote;
  final LocalCacheService _cache;

  CartViewModel({
    required CartRemoteDataSource remote,
    required LocalCacheService cache,
  })  : _remote = remote,
        _cache = cache,
        super(const CartState()) {
    loadCart();
  }

  Future<void> loadCart() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final items = await _remote.getCart();
    state = state.copyWith(items: items, isLoading: false);
  }

  void _syncCache() {
    _cache.saveCart(
      state.items.map((i) => (i as CartItemModel).toJson()).toList(),
    );
  }

  void addToCart(Product product) {
    _addItem(
      productId: product.id,
      productName: product.name,
      price: product.price,
      image: product.image,
    );
  }

  void addToCartById({
    required String productId,
    required String productName,
    required double price,
    String? productImage,
  }) {
    _addItem(
      productId: productId,
      productName: productName,
      price: price,
      image: productImage,
    );
  }

  void _addItem({
    required String productId,
    required String productName,
    required double price,
    String? image,
  }) {
    final existingIndex =
        state.items.indexWhere((i) => i.productId == productId);
    if (existingIndex >= 0) {
      final updated = [...state.items];
      updated[existingIndex] = updated[existingIndex]
          .copyWith(quantity: updated[existingIndex].quantity + 1);
      state = state.copyWith(items: updated);
    } else {
      final newItem = CartItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: productId,
        productName: productName,
        price: price,
        quantity: 1,
        image: image,
      );
      state = state.copyWith(items: [...state.items, newItem]);
    }
    _syncCache();
    _remote.addItem(
      productId: productId,
      productName: productName,
      price: price,
      quantity: 1,
      image: image,
    ).then((serverItem) {
      if (serverItem != null) {
        final updated = state.items.map((item) {
          if (item.productId == productId && item.id != serverItem.id) {
            return serverItem;
          }
          return item;
        }).toList();
        state = state.copyWith(items: updated);
        _syncCache();
      }
    });
  }

  void removeFromCart(String productId) {
    state = state.copyWith(
      items: state.items.where((i) => i.productId != productId).toList(),
    );
    _syncCache();
    _remote.removeItem(productId);
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    state = state.copyWith(
      items: state.items.map((item) {
        if (item.productId == productId) return item.copyWith(quantity: quantity);
        return item;
      }).toList(),
    );
    _syncCache();
    _remote.updateQuantity(productId, quantity);
  }

  void clearCart() {
    state = const CartState();
    _cache.clearCart();
    _remote.clearCart();
  }

  double get totalAmount {
    return state.items.fold(0, (sum, item) => sum + item.price * item.quantity);
  }
}
