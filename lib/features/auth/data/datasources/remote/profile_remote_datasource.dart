import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../api/api_client.dart';
import '../../../../../api/api_endpoints.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../models/auth_api_model.dart';

class ProfileRemoteDataSource {
  Future<(ApiClient, String)> _getClientAndUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(AppConstants.keyUserId) ?? '';
    return (ApiClient(prefs), userId);
  }

  Future<AuthResponseModel> getProfile() async {
    final (client, userId) = await _getClientAndUserId();
    final response = await client.get(ApiEndpoints.userById(userId));
    return AuthResponseModel.fromJson(response.data);
  }

  Future<AuthResponseModel> updateProfile({
    String? name,
    String? phone,
    String? address,
  }) async {
    final (client, userId) = await _getClientAndUserId();
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (address != null) data['address'] = address;

    final response = await client.put(ApiEndpoints.userById(userId), data: data);
    return AuthResponseModel.fromJson(response.data);
  }
}
