import 'package:dartz/dartz.dart';
import '../entities/auth_entities.dart';
import '../../../../core/error/failures.dart';

abstract class IAuthRepository {
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
