import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../api/api_client.dart';
import '../../../../../api/api_endpoints.dart';
import '../../models/auth_api_model.dart';
import '../auth_datasource.dart';

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  late final ApiClient _apiClient;

  AuthRemoteDatasource({ApiClient? apiClient}) {
    if (apiClient != null) {
      _apiClient = apiClient;
    } else {
      // Initialize with a temporary SharedPreferences instance
      SharedPreferences.getInstance().then((prefs) {
        _apiClient = ApiClient(prefs);
      });
    }
  }

  Future<ApiClient> _getClient() async {
    try {
      return _apiClient;
    } catch (e) {
      final prefs = await SharedPreferences.getInstance();
      _apiClient = ApiClient(prefs);
      return _apiClient;
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final client = await _getClient();
      final response = await client.post(
        ApiConstants.register,
        data: {'name': name, 'email': email, 'password': password},
      );

      if (response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw Exception('Registration failed');
      }
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final client = await _getClient();
      final response = await client.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final client = await _getClient();
      await client.post(ApiConstants.logout);
    } catch (e) {
      throw Exception('Logout error: $e');
    }
  }

  @override
  Future<AuthResponseModel> getProfile() async {
    try {
      final client = await _getClient();
      final response = await client.get(ApiConstants.profile);

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get profile');
      }
    } catch (e) {
      throw Exception('Get profile error: $e');
    }
  }
}
