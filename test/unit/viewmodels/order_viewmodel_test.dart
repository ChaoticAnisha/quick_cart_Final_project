import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quick_cart/core/error/failures.dart';
import 'package:quick_cart/features/orders/domain/entities/order_entity.dart';
import 'package:quick_cart/features/orders/domain/repositories/order_repository.dart';
import 'package:quick_cart/features/orders/domain/usecases/order_usecases.dart';
import 'package:quick_cart/features/orders/presentation/state/order_state.dart';
import 'package:quick_cart/features/orders/presentation/viewmodel/order_viewmodel.dart';

// Mocks
class MockCreateOrderUsecase extends Mock implements CreateOrderUsecase {}
class MockGetUserOrdersUsecase extends Mock implements GetUserOrdersUsecase {}
class MockGetOrderByIdUsecase extends Mock implements GetOrderByIdUsecase {}
class MockCancelOrderUsecase extends Mock implements CancelOrderUsecase {}

void main() {
  late MockCreateOrderUsecase mockCreate;
  late MockGetUserOrdersUsecase mockGetOrders;
  late MockGetOrderByIdUsecase mockGetById;
  late MockCancelOrderUsecase mockCancel;

  final tCreatedAt = DateTime(2025, 6, 10);
  const tItem = OrderItemEntity(
    productId: 'prod-1',
    productName: 'Dal 1kg',
    price: 150,
    quantity: 3,
  );
  final tOrder = OrderEntity(
    id: 'order-42',
    userId: 'user-1',
    items: const [tItem],
    totalAmount: 450,
    status: 'Pending',
    deliveryAddress: 'Lalitpur, Bagmati',
    paymentMethod: 'Khalti',
    createdAt: tCreatedAt,
  );
  const tParams = CreateOrderParams(
    userId: 'user-1',
    items: [tItem],
    totalAmount: 450,
    deliveryAddress: 'Lalitpur, Bagmati',
    paymentMethod: 'Khalti',
  );
  const tFailure = ApiFailure(message: 'Server error', statusCode: 500);

  OrderViewModel makeVM() => OrderViewModel(
        createOrderUsecase: mockCreate,
        getUserOrdersUsecase: mockGetOrders,
        getOrderByIdUsecase: mockGetById,
        cancelOrderUsecase: mockCancel,
      );

  setUp(() {
    mockCreate = MockCreateOrderUsecase();
    mockGetOrders = MockGetUserOrdersUsecase();
    mockGetById = MockGetOrderByIdUsecase();
    mockCancel = MockCancelOrderUsecase();
    registerFallbackValue(tParams);
  });

  // Test 10: loadOrders success → state has orders 
  test('loadOrders() success → status success and orders populated', () async {
    when(() => mockGetOrders()).thenAnswer((_) async => Right([tOrder]));

    final vm = makeVM();
    await vm.loadOrders();

    expect(vm.state.status, OrderLoadStatus.success);
    expect(vm.state.orders.length, 1);
    expect(vm.state.orders.first.id, 'order-42');
    expect(vm.state.orders.first.totalAmount, 450);
  });

  // ── Test 11: placeOrder success → returns entity, currentOrder set ─────
  test('placeOrder() success → returns OrderEntity and updates currentOrder',
      () async {
    when(() => mockCreate(any())).thenAnswer((_) async => Right(tOrder));

    final vm = makeVM();
    final result = await vm.placeOrder(tParams);

    expect(result, isNotNull);
    expect(result!.id, 'order-42');
    expect(result.paymentMethod, 'Khalti');
    expect(vm.state.status, OrderLoadStatus.success);
    expect(vm.state.currentOrder, tOrder);
    expect(vm.state.orders, contains(tOrder));
  });

  // ── Test 12: placeOrder failure → returns null, status error ──────────────
  test('placeOrder() failure → returns null and sets error state', () async {
    when(() => mockCreate(any()))
        .thenAnswer((_) async => const Left(tFailure));

    final vm = makeVM();
    final result = await vm.placeOrder(tParams);

    expect(result, isNull);
    expect(vm.state.status, OrderLoadStatus.error);
    expect(vm.state.errorMessage, 'Server error');
    expect(vm.state.currentOrder, isNull);
  });

  // ── Test 13: loadOrders failure → status error ────────────────────────────
  test('loadOrders() failure → status error and errorMessage set', () async {
    when(() => mockGetOrders())
        .thenAnswer((_) async => const Left(tFailure));

    final vm = makeVM();
    await vm.loadOrders();

    expect(vm.state.status, OrderLoadStatus.error);
    expect(vm.state.errorMessage, 'Server error');
    expect(vm.state.orders, isEmpty);
  });

  // ── Test 14: loadOrderById success → currentOrder set ─────────────────────
  test('loadOrderById() success → currentOrder populated', () async {
    when(() => mockGetById('order-42'))
        .thenAnswer((_) async => Right(tOrder));

    final vm = makeVM();
    await vm.loadOrderById('order-42');

    expect(vm.state.currentOrder, tOrder);
    expect(vm.state.currentOrder!.id, 'order-42');
    expect(vm.state.status, OrderLoadStatus.success);
  });

  // ── Test 15: loadOrderById failure → status error ─────────────────────────
  test('loadOrderById() failure → status error', () async {
    when(() => mockGetById(any()))
        .thenAnswer((_) async => const Left(tFailure));

    final vm = makeVM();
    await vm.loadOrderById('bad-id');

    expect(vm.state.status, OrderLoadStatus.error);
    expect(vm.state.currentOrder, isNull);
  });
}
