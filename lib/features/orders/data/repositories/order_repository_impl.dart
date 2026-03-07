import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';

final orderRepositoryImplProvider = Provider<IOrderRepository>((ref) {
  return OrderRepositoryImpl(OrderRemoteDataSource());
});

class OrderRepositoryImpl implements IOrderRepository {
  final OrderRemoteDataSource _dataSource;
  OrderRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, OrderEntity>> createOrder(
      CreateOrderParams params) async {
    try {
      final order = await _dataSource.createOrder(params);
      return Right(order);
    } on DioException catch (e) {
      return Left(ApiFailure(
        message: e.response?.data['message'] ?? 'Failed to place order',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getUserOrders() async {
    try {
      final orders = await _dataSource.getUserOrders();
      return Right(orders);
    } on DioException catch (e) {
      return Left(ApiFailure(
        message: e.response?.data['message'] ?? 'Failed to fetch orders',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String id) async {
    try {
      final order = await _dataSource.getOrderById(id);
      return Right(order);
    } on DioException catch (e) {
      return Left(ApiFailure(
        message: e.response?.data['message'] ?? 'Failed to fetch order',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> cancelOrder(String id) async {
    try {
      final order = await _dataSource.cancelOrder(id);
      return Right(order);
    } on DioException catch (e) {
      return Left(ApiFailure(
        message: e.response?.data['message'] ?? 'Failed to cancel order',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
