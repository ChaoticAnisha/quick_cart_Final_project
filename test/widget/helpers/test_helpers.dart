import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_cart/core/error/failures.dart';
import 'package:quick_cart/core/services/storage/local_cache_service.dart';
import 'package:quick_cart/features/auth/domain/entities/user.dart';
import 'package:quick_cart/features/auth/presentation/state/auth_state.dart';
import 'package:quick_cart/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:quick_cart/features/cart/data/datasources/remote/cart_remote_datasource.dart';
import 'package:quick_cart/features/cart/data/models/cart_item_model.dart';
import 'package:quick_cart/features/cart/presentation/state/cart_state.dart';
import 'package:quick_cart/features/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:quick_cart/features/orders/domain/entities/order_entity.dart';
import 'package:quick_cart/features/orders/domain/repositories/order_repository.dart';
import 'package:quick_cart/features/orders/domain/usecases/order_usecases.dart';
import 'package:quick_cart/features/orders/presentation/state/order_state.dart';
import 'package:quick_cart/features/orders/presentation/viewmodel/order_viewmodel.dart';
import 'package:quick_cart/features/products/presentation/state/product_state.dart';
import 'package:quick_cart/features/products/presentation/viewmodel/product_viewmodel.dart';
import 'package:quick_cart/features/checkout/presentation/state/checkout_state.dart';
import 'package:quick_cart/features/checkout/presentation/viewmodel/checkout_viewmodel.dart';
import 'package:quick_cart/features/products/domain/entities/product.dart';
import 'package:quick_cart/features/products/presentation/viewmodel/recently_viewed_viewmodel.dart';
import 'package:quick_cart/features/wishlist/presentation/viewmodel/wishlist_viewmodel.dart';

// ─── No-Op implementations ────────────────────────────────────────────────────

class _NoOpCartDS extends Fake implements CartRemoteDataSource {
  @override
  Future<List<CartItemModel>> getCart() async => [];

  @override
  Future<CartItemModel?> addItem({
    required String productId,
    required String productName,
    required double price,
    int quantity = 1,
    String? image,
  }) async =>
      null;

  @override
  Future<bool> updateQuantity(String productId, int quantity) async => true;

  @override
  Future<bool> removeItem(String productId) async => true;

  @override
  Future<bool> clearCart() async => true;
}

class _NoOpCache extends Fake implements LocalCacheService {
  @override
  Future<void> saveCart(List<Map<String, dynamic>> items) async {}

  @override
  Future<List<Map<String, dynamic>>> getCart() async => [];

  @override
  Future<void> clearCart() async {}

  @override
  Future<void> saveProducts(List<Map<String, dynamic>> p) async {}

  @override
  Future<List<Map<String, dynamic>>> getProducts() async => [];

  @override
  Future<void> saveCategories(List<Map<String, dynamic>> c) async {}

  @override
  Future<List<Map<String, dynamic>>> getCategories() async => [];
}

class _NoOpOrderRepo implements IOrderRepository {
  @override
  Future<Either<Failure, OrderEntity>> createOrder(
          CreateOrderParams params) async =>
      const Left(ApiFailure(message: 'NoOp'));

  @override
  Future<Either<Failure, List<OrderEntity>>> getUserOrders() async =>
      const Right([]);

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String id) async =>
      const Left(ApiFailure(message: 'NoOp'));

  @override
  Future<Either<Failure, OrderEntity>> cancelOrder(String id) async =>
      const Left(ApiFailure(message: 'NoOp'));
}

/// Fake WishlistViewModel — returns empty list, no Hive access.
class FakeWishlistViewModel extends StateNotifier<List<Product>>
    implements WishlistViewModel {
  FakeWishlistViewModel() : super([]);
  @override
  bool isWishlisted(String productId) => false;
  @override
  void toggle(Product product) {}
}

/// Fake RecentlyViewedViewModel — returns empty list, no Hive access.
class FakeRecentlyViewedViewModel extends StateNotifier<List<Product>>
    implements RecentlyViewedViewModel {
  FakeRecentlyViewedViewModel() : super([]);
  @override
  void track(Product product) {}
}

// ─── Fake ViewModels ──────────────────────────────────────────────────────────

/// Fake AuthViewModel — skips usecase initialization; returns preset state.
class FakeAuthViewModel extends AuthViewModel {
  final AuthState _preset;
  FakeAuthViewModel(this._preset);

  @override
  AuthState build() => _preset;

  @override
  Future<void> login(
      {required String email, required String password}) async {}

  @override
  Future<void> register(
      {required String name,
      required String email,
      required String password}) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<bool> forgotPassword({required String email}) async => false;

  @override
  Future<void> fetchCurrentUser() async {}

  @override
  void clearError() {}

  @override
  void updateUser(User user) {}
}

/// Fake CartViewModel — uses no-op datasources; loadCart sets preset state.
class FakeCartViewModel extends CartViewModel {
  final CartState _preset;

  FakeCartViewModel(this._preset)
      : super(remote: _NoOpCartDS(), cache: _NoOpCache());

  @override
  Future<void> loadCart() async {
    state = _preset;
  }
}

/// Fake OrderViewModel — no-op usecases; loadOrders sets preset state.
class FakeOrderViewModel extends OrderViewModel {
  final OrderState _preset;
  static final _repo = _NoOpOrderRepo();

  FakeOrderViewModel(this._preset)
      : super(
          createOrderUsecase: CreateOrderUsecase(_repo),
          getUserOrdersUsecase: GetUserOrdersUsecase(_repo),
          getOrderByIdUsecase: GetOrderByIdUsecase(_repo),
          cancelOrderUsecase: CancelOrderUsecase(_repo),
        );

  @override
  Future<void> loadOrders() async {
    state = _preset;
  }
}

/// Fake ProductViewModel — no network calls; exposes preset state immediately.
class FakeProductViewModel extends ProductViewModel {
  final ProductState _preset;

  FakeProductViewModel(this._preset) {
    state = _preset;
  }

  @override
  Future<void> loadProducts() async => state = _preset;

  @override
  Future<void> loadCategories() async => state = _preset;

  @override
  Future<void> searchProducts(String query) async {}

  @override
  Future<void> filterByCategory(String categoryId) async {}

  @override
  void clearFilter() {}
}

/// Fake CheckoutViewModel — returns preset state, no real order calls.
class FakeCheckoutViewModel extends CheckoutViewModel {
  final CheckoutState _preset;

  // A lightweight stand-in Ref that will never be called during widget tests.
  static final _fakeRef = _NullRef();

  FakeCheckoutViewModel(this._preset) : super(_fakeRef) {
    state = _preset;
  }

  @override
  void selectPayment(String method) =>
      state = state.copyWith(selectedPayment: method);

  @override
  Future<OrderEntity?> placeOrder({required String deliveryAddress}) async =>
      null;

  @override
  void clearError() => state = state.copyWith(clearError: true);
}

/// Minimal Ref stub for FakeCheckoutViewModel construction.
class _NullRef implements Ref {
  @override
  dynamic noSuchMethod(Invocation i) => null;
}

// ─── Pump helper ──────────────────────────────────────────────────────────────

/// Pumps [screen] inside a [ProviderScope] + [MaterialApp] with stub routes.
Future<void> pumpScreen(
  WidgetTester tester,
  Widget screen, {
  List<Override> overrides = const [],
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        home: screen,
        routes: {
          '/login': (_) => const Scaffold(body: Text('Login Page')),
          '/register': (_) => const Scaffold(body: Text('Register Page')),
          '/dashboard': (_) => const Scaffold(body: Text('Dashboard Page')),
          '/cart': (_) => const Scaffold(body: Text('Cart Page')),
          '/orders': (_) => const Scaffold(body: Text('Orders Page')),
          '/forgot-password': (_) =>
              const Scaffold(body: Text('Forgot Password Page')),
          '/profile': (_) => const Scaffold(body: Text('Profile Page')),
          '/category': (_) => const Scaffold(body: Text('Category Page')),
        },
      ),
    ),
  );
}
