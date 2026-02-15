import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_entities.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';
import '../datasources/local/auth_local_datasource.dart';

final authRepositoryImplProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl(
    authRemoteDataSource: ref.read(authRemoteProvider),
    authLocalDataSource: ref.read(authLocalProvider),
  );
});

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource _authRemoteDataSource;
  final IAuthLocalDataSource _authLocalDataSource;

  AuthRepositoryImpl({
    required IAuthRemoteDataSource authRemoteDataSource,
    required IAuthLocalDataSource authLocalDataSource,
  }) : _authRemoteDataSource = authRemoteDataSource,
       _authLocalDataSource = authLocalDataSource;

  @override
  Future<Either<Failure, bool>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authRemoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );

      final userData = response.data;
      final token = userData['token'];

      if (token != null) {
        await _authLocalDataSource.saveUserSession(
          token: token,
          userId: userData['user']['id'] ?? '',
          email: userData['user']['email'],
          name: userData['user']['name'],
        );
      }

      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Registration failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await _authRemoteDataSource.login(
        email: email,
        password: password,
      );

      final userData = response.data;
      final token = userData['token'];
      final user = userData['user'];

      if (token != null) {
        await _authLocalDataSource.saveUserSession(
          token: token,
          userId: user['id'] ?? user['_id'] ?? '',
          email: user['email'],
          name: user['name'],
        );
      }

      return Right(
        AuthEntity(
          id: user['id'] ?? user['_id'],
          name: user['name'],
          email: user['email'],
          phone: user['phone'],
          address: user['address'],
          profilePicture: user['profilePicture'],
        ),
      );
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Login failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await _authRemoteDataSource.logout();
      await _authLocalDataSource.clearSession();
      return const Right(true);
    } on DioException catch (e) {
      await _authLocalDataSource.clearSession();
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Logout failed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      await _authLocalDataSource.clearSession();
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final response = await _authRemoteDataSource.getProfile();
      final user = response.data;

      return Right(
        AuthEntity(
          id: user['id'] ?? user['_id'],
          name: user['name'],
          email: user['email'],
          phone: user['phone'],
          address: user['address'],
          profilePicture: user['profilePicture'],
        ),
      );
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch user',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final loggedIn = await _authLocalDataSource.isLoggedIn();
      return Right(loggedIn);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
