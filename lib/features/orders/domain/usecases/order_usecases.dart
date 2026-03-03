import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';
import '../../data/repositories/order_repository_impl.dart';

final createOrderUsecaseProvider = Provider<CreateOrderUsecase>((ref) {
  return CreateOrderUsecase(ref.read(orderRepositoryImplProvider));
});

class CreateOrderUsecase {
  final IOrderRepository _repo;
  CreateOrderUsecase(this._repo);

  Future<Either<Failure, OrderEntity>> call(CreateOrderParams params) =>
      _repo.createOrder(params);
}

final getUserOrdersUsecaseProvider = Provider<GetUserOrdersUsecase>((ref) {
  return GetUserOrdersUsecase(ref.read(orderRepositoryImplProvider));
});

class GetUserOrdersUsecase {
  final IOrderRepository _repo;
  GetUserOrdersUsecase(this._repo);

  Future<Either<Failure, List<OrderEntity>>> call() => _repo.getUserOrders();
}

final getOrderByIdUsecaseProvider = Provider<GetOrderByIdUsecase>((ref) {
  return GetOrderByIdUsecase(ref.read(orderRepositoryImplProvider));
});

class GetOrderByIdUsecase {
  final IOrderRepository _repo;
  GetOrderByIdUsecase(this._repo);

  Future<Either<Failure, OrderEntity>> call(String id) =>
      _repo.getOrderById(id);
}

final cancelOrderUsecaseProvider = Provider<CancelOrderUsecase>((ref) {
  return CancelOrderUsecase(ref.read(orderRepositoryImplProvider));
});

class CancelOrderUsecase {
  final IOrderRepository _repo;
  CancelOrderUsecase(this._repo);

  Future<Either<Failure, OrderEntity>> call(String id) =>
      _repo.cancelOrder(id);
}
