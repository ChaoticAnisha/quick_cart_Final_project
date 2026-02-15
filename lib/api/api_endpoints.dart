class ApiEndpoints {
  // REPLACE 192.168.1.100 WITH YOUR ACTUAL IP ADDRESS
  static const String baseUrl = 'http://192.168.1.100:3000/api';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth endpoints
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';
  static const String getProfile = '$baseUrl/auth/profile';
  static const String updateProfile = '$baseUrl/auth/profile';
  static const String updateProfilePicture = '$baseUrl/auth/profile/picture';

  // Base URL for uploads
  static const String uploadsBaseUrl = 'http://192.168.1.100:3000';

  // Helper to get full image URL
  static String getImageUrl(String path) {
    if (path.startsWith('http')) {
      return path;
    }
    return '$uploadsBaseUrl$path';
  }
}

// Alias for backward compatibility
class ApiConstants {
  static const String baseUrl = ApiEndpoints.baseUrl;
  static const Duration connectionTimeout = ApiEndpoints.connectionTimeout;
  static const Duration receiveTimeout = ApiEndpoints.receiveTimeout;
  static const String register = ApiEndpoints.register;
  static const String login = ApiEndpoints.login;
  static const String logout = ApiEndpoints.logout;
  static const String profile = ApiEndpoints.getProfile;
}
