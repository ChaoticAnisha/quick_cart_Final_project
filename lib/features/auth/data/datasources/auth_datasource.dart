import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'local/auth_local_datasource.dart';
import 'remote/auth_remote_datasource.dart';
import '../models/auth_api_model.dart';

// Providers for data sources
final authRemoteProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource();
});

final authLocalProvider = Provider<IAuthLocalDataSource>((ref) {
  return AuthLocalDatasource();
});

// Interface for remote data source
abstract class IAuthRemoteDataSource {
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  });
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<AuthResponseModel> getProfile();
}

// Interface for local data source
abstract class IAuthLocalDataSource {
  Future<void> saveUserSession({
    required String token,
    required String userId,
    required String email,
    required String name,
  });
  Future<String?> getToken();
  Future<bool> isLoggedIn();
  Future<void> clearSession();
}
