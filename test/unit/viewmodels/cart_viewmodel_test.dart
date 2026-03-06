import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quick_cart/core/services/storage/local_cache_service.dart';
import 'package:quick_cart/features/cart/data/datasources/remote/cart_remote_datasource.dart';
import 'package:quick_cart/features/cart/presentation/viewmodel/cart_viewmodel.dart';

// Mocks
class MockCartRemoteDataSource extends Mock implements CartRemoteDataSource {}
class MockLocalCacheService extends Mock implements LocalCacheService {}

void main() {
  late MockCartRemoteDataSource mockRemote;
  late MockLocalCacheService mockCache;

  const tProductId = 'prod-1';
  const tProductName = 'Rice Bag 5kg';
  const tPrice = 450.0;

  // Helper: create CartViewModel with mocked deps
  CartViewModel makeVM() {
    return CartViewModel(remote: mockRemote, cache: mockCache);
  }

  setUp(() {
    mockRemote = MockCartRemoteDataSource();
    mockCache = MockLocalCacheService();

    // Default stubs so constructor's loadCart() doesn't fail
    when(() => mockRemote.getCart()).thenAnswer((_) async => []);
    when(() => mockCache.saveCart(any())).thenAnswer((_) async {});
    when(() => mockCache.clearCart()).thenAnswer((_) async {});
  });

  // ── Test 5: addToCartById adds new item ───────────────────────────────────
  test('addToCartById() adds new item to state', () async {
    // stub addItem for fire-and-forget call
    when(() => mockRemote.addItem(
          productId: any(named: 'productId'),
          productName: any(named: 'productName'),
          price: any(named: 'price'),
          quantity: any(named: 'quantity'),
          image: any(named: 'image'),
        )).thenAnswer((_) async => null);

    final vm = makeVM();
    await Future.delayed(Duration.zero); // let loadCart() complete

    vm.addToCartById(
      productId: tProductId,
      productName: tProductName,
      price: tPrice,
    );

    expect(vm.state.items.length, 1);
    expect(vm.state.items.first.productId, tProductId);
    expect(vm.state.items.first.productName, tProductName);
    expect(vm.state.items.first.price, tPrice);
    expect(vm.state.items.first.quantity, 1);
  });

  // ── Test 6: addToCartById increments qty for existing item ────────────────
  test('addToCartById() increments quantity for an existing item', () async {
    when(() => mockRemote.addItem(
          productId: any(named: 'productId'),
          productName: any(named: 'productName'),
          price: any(named: 'price'),
          quantity: any(named: 'quantity'),
          image: any(named: 'image'),
        )).thenAnswer((_) async => null);

    final vm = makeVM();
    await Future.delayed(Duration.zero);

    vm.addToCartById(
        productId: tProductId, productName: tProductName, price: tPrice);
    vm.addToCartById(
        productId: tProductId, productName: tProductName, price: tPrice);

    expect(vm.state.items.length, 1);
    expect(vm.state.items.first.quantity, 2);
  });

  // ── Test 7: removeFromCart removes item ───────────────────────────────────
  test('removeFromCart() removes the item from state', () async {
    when(() => mockRemote.addItem(
          productId: any(named: 'productId'),
          productName: any(named: 'productName'),
          price: any(named: 'price'),
          quantity: any(named: 'quantity'),
          image: any(named: 'image'),
        )).thenAnswer((_) async => null);
    when(() => mockRemote.removeItem(any())).thenAnswer((_) async => true);

    final vm = makeVM();
    await Future.delayed(Duration.zero);

    vm.addToCartById(
        productId: tProductId, productName: tProductName, price: tPrice);
    expect(vm.state.items.length, 1);

    vm.removeFromCart(tProductId);
    expect(vm.state.items, isEmpty);
  });

  // ── Test 8: updateQuantity updates qty correctly ──────────────────────────
  test('updateQuantity() updates item quantity in state', () async {
    when(() => mockRemote.addItem(
          productId: any(named: 'productId'),
          productName: any(named: 'productName'),
          price: any(named: 'price'),
          quantity: any(named: 'quantity'),
          image: any(named: 'image'),
        )).thenAnswer((_) async => null);
    when(() => mockRemote.updateQuantity(any(), any()))
        .thenAnswer((_) async => true);

    final vm = makeVM();
    await Future.delayed(Duration.zero);

    vm.addToCartById(
        productId: tProductId, productName: tProductName, price: tPrice);
    vm.updateQuantity(tProductId, 5);

    expect(vm.state.items.first.quantity, 5);
  });

  // ── Test 9: clearCart empties state ──────────────────────────────────────
  test('clearCart() empties the cart state', () async {
    when(() => mockRemote.addItem(
          productId: any(named: 'productId'),
          productName: any(named: 'productName'),
          price: any(named: 'price'),
          quantity: any(named: 'quantity'),
          image: any(named: 'image'),
        )).thenAnswer((_) async => null);
    when(() => mockRemote.clearCart()).thenAnswer((_) async => true);

    final vm = makeVM();
    await Future.delayed(Duration.zero);

    vm.addToCartById(
        productId: tProductId, productName: tProductName, price: tPrice);
    expect(vm.state.items.length, 1);

    vm.clearCart();
    expect(vm.state.items, isEmpty);
    verify(() => mockRemote.clearCart()).called(1);
  });
}
