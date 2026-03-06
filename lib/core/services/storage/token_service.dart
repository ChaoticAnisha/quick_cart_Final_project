import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_constants.dart';

class TokenService {
  final SharedPreferences _prefs;

  TokenService(this._prefs);

  // Save token
  Future<bool> saveToken(String token) async {
    return await _prefs.setString(AppConstants.keyAccessToken, token);
  }

  // Get token
  String? getToken() {
    return _prefs.getString(AppConstants.keyAccessToken);
  }

  // Remove token
  Future<bool> removeToken() async {
    return await _prefs.remove(AppConstants.keyAccessToken);
  }

  // Check if logged in
  bool isLoggedIn() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  // Save user data
  Future<void> saveUserData({
    required String userId,
    required String email,
    required String role,
    String? name,
    String? phone,
    String? address,
    String? avatar,
  }) async {
    await Future.wait([
      _prefs.setString(AppConstants.keyUserId, userId),
      _prefs.setString(AppConstants.keyUserEmail, email),
      _prefs.setString(AppConstants.keyUserRole, role),
      if (name != null) _prefs.setString(AppConstants.keyUserName, name),
      if (phone != null) _prefs.setString(AppConstants.keyUserPhone, phone),
      if (address != null)
        _prefs.setString(AppConstants.keyUserAddress, address),
      if (avatar != null) _prefs.setString(AppConstants.keyUserAvatar, avatar),
      _prefs.setBool(AppConstants.keyIsLoggedIn, true),
    ]);
  }

  // Get user data
  Map<String, String?> getUserData() {
    return {
      'userId': _prefs.getString(AppConstants.keyUserId),
      'email': _prefs.getString(AppConstants.keyUserEmail),
      'role': _prefs.getString(AppConstants.keyUserRole),
      'name': _prefs.getString(AppConstants.keyUserName),
      'phone': _prefs.getString(AppConstants.keyUserPhone),
      'address': _prefs.getString(AppConstants.keyUserAddress),
      'avatar': _prefs.getString(AppConstants.keyUserAvatar),
    };
  }

  // Get user ID
  String? getUserId() {
    return _prefs.getString(AppConstants.keyUserId);
  }

  // Get user email
  String? getUserEmail() {
    return _prefs.getString(AppConstants.keyUserEmail);
  }

  // Get user role
  String? getUserRole() {
    return _prefs.getString(AppConstants.keyUserRole);
  }

  // Check if user is admin
  bool isAdmin() {
    return getUserRole() == 'admin';
  }

  // Clear all user data
  Future<void> clearAll() async {
    await Future.wait([
      _prefs.remove(AppConstants.keyAccessToken),
      _prefs.remove(AppConstants.keyUserId),
      _prefs.remove(AppConstants.keyUserEmail),
      _prefs.remove(AppConstants.keyUserRole),
      _prefs.remove(AppConstants.keyUserName),
      _prefs.remove(AppConstants.keyUserPhone),
      _prefs.remove(AppConstants.keyUserAddress),
      _prefs.remove(AppConstants.keyUserAvatar),
      _prefs.setBool(AppConstants.keyIsLoggedIn, false),
    ]);
  }

  // First time setup
  Future<void> setFirstTime(bool value) async {
    await _prefs.setBool(AppConstants.keyIsFirstTime, value);
  }

  bool isFirstTime() {
    return _prefs.getBool(AppConstants.keyIsFirstTime) ?? true;
  }
}
