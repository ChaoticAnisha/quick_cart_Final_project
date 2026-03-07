import 'package:flutter/foundation.dart' show kIsWeb;

class ApiEndpoints {
  /// Web (Chrome) → localhost:5000   |   Emulator/Device → WSL2 IP (run: wsl hostname -I)
  static String get baseUrl =>
      kIsWeb ? 'http://localhost:5000/api' : 'http://10.0.2.2:5000/api';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth endpoints (relative — used with ApiClient which adds baseUrl)
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String getProfile = '/auth/profile';
  static const String updateProfile = '/auth/profile';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // Product endpoints
  static const String products = '/products';
  static const String getAllProducts = '/products';
  static const String categories = '/categories';

  // Cart endpoints
  static const String cart = '/cart';

  // Order endpoints
  static const String orders = '/orders';
  static String cancelOrder(String id) => '/orders/$id/cancel';

  // User endpoints
  static const String userDashboard = '/users/dashboard';
  static const String uploadAvatar = '/users';
  static String userById(String userId) => '/users/$userId';
  static String userAvatar(String userId) => '/users/$userId/avatar';

  // Base URL for serving uploaded images
  static String get uploadsBaseUrl =>
      kIsWeb ? 'http://localhost:5000' : 'http://10.0.2.2:5000';

  // Returns true if the image should be loaded from network
  static bool isNetworkImage(String path) {
    if (path.isEmpty) return false;
    return path.startsWith('http') || path.startsWith('/');
  }

  // Helper: ensure full URL for network images coming from backend
  static String getImageUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final separator = path.startsWith('/') ? '' : '/';
    return '$uploadsBaseUrl$separator$path';
  }

  // Returns local asset path for bundled images (e.g. "milk.png" → "assets/images/milk.png")
  static String getAssetImagePath(String path) {
    return 'assets/images/$path';
  }
}

// Alias kept for backward compatibility
class ApiConstants {
  static String get baseUrl => ApiEndpoints.baseUrl;
  static const Duration connectionTimeout = ApiEndpoints.connectionTimeout;
  static const Duration receiveTimeout = ApiEndpoints.receiveTimeout;
  static const String register = ApiEndpoints.register;
  static const String login = ApiEndpoints.login;
  static const String logout = ApiEndpoints.logout;
  static const String profile = ApiEndpoints.getProfile;
}
