import '../models/auth_api_model.dart';

abstract interface class IAuthRemoteDataSource {
  Future<AuthApiModel> register(String name, String email, String password);
  Future<AuthApiModel> login(String email, String password);
  Future<void> logout();
  Future<AuthApiModel> getCurrentUser();
}

abstract interface class IAuthLocalDataSource {
  Future<void> saveUserSession({
    required String token,
    required String userId,
    required String email,
    required String name,
  });

  Future<bool> isLoggedIn();
  Future<String?> getToken();
  Future<String?> getUserId();
  Future<void> clearSession();
}
