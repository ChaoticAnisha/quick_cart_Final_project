import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';
import '../../data/repositories/order_repository_impl.dart';

// ── Create Order ─────────────────────────────────────────────────────────────

final createOrderUsecaseProvider = Provider<CreateOrderUsecase>((ref) {
  return CreateOrderUsecase(ref.read(orderRepositoryImplProvider));
});

class CreateOrderUsecase {
  final IOrderRepository _repo;
  CreateOrderUsecase(this._repo);

  Future<Either<Failure, OrderEntity>> call(CreateOrderParams params) =>
      _repo.createOrder(params);
}

// ── Get User Orders ──────────────────────────────────────────────────────────

final getUserOrdersUsecaseProvider = Provider<GetUserOrdersUsecase>((ref) {
  return GetUserOrdersUsecase(ref.read(orderRepositoryImplProvider));
});

class GetUserOrdersUsecase {
  final IOrderRepository _repo;
  GetUserOrdersUsecase(this._repo);

  Future<Either<Failure, List<OrderEntity>>> call() => _repo.getUserOrders();
}

// ── Get Order By ID ──────────────────────────────────────────────────────────

final getOrderByIdUsecaseProvider = Provider<GetOrderByIdUsecase>((ref) {
  return GetOrderByIdUsecase(ref.read(orderRepositoryImplProvider));
});

class GetOrderByIdUsecase {
  final IOrderRepository _repo;
  GetOrderByIdUsecase(this._repo);

  Future<Either<Failure, OrderEntity>> call(String id) =>
      _repo.getOrderById(id);
}
