import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_cart/api/api_endpoints.dart';
import 'package:quick_cart/api/api_client.dart';
import 'package:quick_cart/features/auth/data/models/auth_api_model.dart';
import 'package:quick_cart/features/auth/data/datasources/auth_datasource.dart';

final authRemoteProvider = Provider<IAuthRemoteDataSource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AuthRemoteDatasource(apiClient: apiClient);
});

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<AuthApiModel> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] ?? response.data;
        return AuthApiModel.fromJson(data);
      } else {
        throw Exception(response.data['message'] ?? 'Registration failed');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Registration failed: ${e.message}',
      );
    }
  }

  @override
  Future<AuthApiModel> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return AuthApiModel.fromJson(data);
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Login failed: ${e.message}',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiConstants.logout);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Logout failed: ${e.message}',
      );
    }
  }

  @override
  Future<AuthApiModel> getCurrentUser() async {
    try {
      final response = await _apiClient.get(ApiConstants.profile);

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data['user'];
        return AuthApiModel.fromJson(data);
      } else {
        throw Exception('Failed to fetch profile');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch profile');
    }
  }
}
