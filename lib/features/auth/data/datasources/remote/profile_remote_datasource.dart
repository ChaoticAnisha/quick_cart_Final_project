import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../api/api_endpoints.dart';
import '../../../../../core/services/storage/session_service.dart';
import '../../models/auth_api_model.dart';

class ProfileRemoteDataSource {
  final Dio _dio;
  final SessionService _sessionService;

  ProfileRemoteDataSource({Dio? dio, SessionService? sessionService})
    : _dio = dio ?? Dio(),
      _sessionService = sessionService ?? SessionService();

  Future<AuthResponseModel> getProfile() async {
    try {
      final token = await _sessionService.getToken();

      final response = await _dio.get(
        ApiEndpoints.getProfile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return AuthResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  Future<AuthResponseModel> updateProfile({
    String? name,
    String? phone,
    String? address,
  }) async {
    try {
      final token = await _sessionService.getToken();

      final Map<String, dynamic> data = {};
      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      if (address != null) data['address'] = address;

      final response = await _dio.put(
        ApiEndpoints.updateProfile,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return AuthResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<AuthResponseModel> updateProfilePicture(XFile image) async {
    try {
      final token = await _sessionService.getToken();

      // Read image bytes
      final bytes = await image.readAsBytes();

      FormData formData = FormData.fromMap({
        'profilePicture': MultipartFile.fromBytes(bytes, filename: image.name),
      });

      final response = await _dio.post(
        ApiEndpoints.updateProfilePicture,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return AuthResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update profile picture: $e');
    }
  }
}

class SessionService {
  Future<dynamic> getToken() async {}
}
