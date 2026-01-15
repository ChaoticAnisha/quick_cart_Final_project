import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../domain/entities/auth_entities.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';

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
      final apiModel = await _authRemoteDataSource.register(
        name,
        email,
        password,
      );

      // Save user session after successful registration
      if (apiModel.token != null) {
        await _authLocalDataSource.saveUserSession(
          token: apiModel.token!,
          userId: apiModel.id ?? '',
          email: apiModel.email,
          name: apiModel.name,
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
      final apiModel = await _authRemoteDataSource.login(email, password);

      // Save user session after successful login
      if (apiModel.token != null) {
        await _authLocalDataSource.saveUserSession(
          token: apiModel.token!,
          userId: apiModel.id ?? '',
          email: apiModel.email,
          name: apiModel.name,
        );
      }

      return Right(apiModel.toEntity());
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
      // Even if API call fails, clear local session
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
      final apiModel = await _authRemoteDataSource.getCurrentUser();
      return Right(apiModel.toEntity());
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
