import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/auth_entities.dart';
import '../../../../core/error/failures.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl(
    authRemoteDataSource: ref.read(authRemoteProvider),
    authLocalDataSource: ref.read(authLocalProvider),
  );
});

abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthEntity>> login(String email, String password);

  Future<Either<Failure, bool>> logout();

  Future<Either<Failure, AuthEntity>> getCurrentUser();

  Future<Either<Failure, bool>> isLoggedIn();
}
