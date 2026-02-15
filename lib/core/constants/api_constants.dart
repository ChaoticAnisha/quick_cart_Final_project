class ApiConstants {
  // Backend running on port 5000
  static const String baseUrl = 'http://192.168.1.100:5000/api';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String profile = '/auth/profile';
  static const String updateProfile = '/auth/profile';
  static const String uploadAvatar = '/auth/upload-avatar';

  // Image Base
  static const String imageBaseUrl = 'http://192.168.1.100:5000';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
