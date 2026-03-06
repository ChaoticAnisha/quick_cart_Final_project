import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quick_cart/core/error/failures.dart';
import 'package:quick_cart/features/orders/domain/entities/order_entity.dart';
import 'package:quick_cart/features/orders/domain/repositories/order_repository.dart';
import 'package:quick_cart/features/orders/domain/usecases/order_usecases.dart';

// Mock
class MockOrderRepository extends Mock implements IOrderRepository {}

void main() {
  late MockOrderRepository mockRepo;

  // Shared test data
  final tCreatedAt = DateTime(2025, 1, 15);
  const tItem = OrderItemEntity(
    productId: 'prod-1',
    productName: 'Rice Bag',
    price: 500,
    quantity: 2,
  );
  final tOrder = OrderEntity(
    id: 'order-1',
    userId: 'user-1',
    items: const [tItem],
    totalAmount: 1000,
    status: 'Pending',
    deliveryAddress: 'Kathmandu, Bagmati',
    paymentMethod: 'COD',
    createdAt: tCreatedAt,
  );
  const tParams = CreateOrderParams(
    items: [tItem],
    totalAmount: 1000,
    deliveryAddress: 'Kathmandu, Bagmati',
    paymentMethod: 'COD',
  );
  const tFailure = ApiFailure(message: 'Order creation failed', statusCode: 500);

  setUp(() {
    mockRepo = MockOrderRepository();
    registerFallbackValue(tParams);
  });

  // ── 7. CreateOrderUsecase — success ───────────────────────────────────────
  group('CreateOrderUsecase', () {
    test('returns Right(OrderEntity) on successful order creation', () async {
      when(() => mockRepo.createOrder(any()))
          .thenAnswer((_) async => Right(tOrder));

      final usecase = CreateOrderUsecase(mockRepo);
      final result = await usecase(tParams);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (order) {
          expect(order.id, 'order-1');
          expect(order.totalAmount, 1000);
          expect(order.status, 'Pending');
          expect(order.items.length, 1);
        },
      );
    });

    // ── 8. CreateOrderUsecase — failure ────────────────────────────────────
    test('returns Left(Failure) on order creation failure', () async {
      when(() => mockRepo.createOrder(any()))
          .thenAnswer((_) async => const Left(tFailure));

      final usecase = CreateOrderUsecase(mockRepo);
      final result = await usecase(tParams);

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f.message, 'Order creation failed'),
        (_) => fail('Expected Left'),
      );
    });
  });

  // ── 9. GetUserOrdersUsecase — success ─────────────────────────────────────
  group('GetUserOrdersUsecase', () {
    test('returns Right(List<OrderEntity>) with user order history', () async {
      when(() => mockRepo.getUserOrders())
          .thenAnswer((_) async => Right([tOrder]));

      final usecase = GetUserOrdersUsecase(mockRepo);
      final result = await usecase();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (orders) {
          expect(orders.length, 1);
          expect(orders.first.id, 'order-1');
        },
      );
    });
  });

  // ── 10. GetOrderByIdUsecase — success ─────────────────────────────────────
  group('GetOrderByIdUsecase', () {
    test('returns Right(OrderEntity) for a given order ID', () async {
      when(() => mockRepo.getOrderById('order-1'))
          .thenAnswer((_) async => Right(tOrder));

      final usecase = GetOrderByIdUsecase(mockRepo);
      final result = await usecase('order-1');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (order) => expect(order.paymentMethod, 'COD'),
      );
      verify(() => mockRepo.getOrderById('order-1')).called(1);
    });
  });
}
