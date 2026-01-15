class AppConstants {
  static const String appName = 'QuickCart';
  static const String appVersion = '1.0.0';

  // SharedPreferences Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyUserName = 'user_name';
  static const String keyIsLoggedIn = 'is_logged_in';

  // Error Messages
  static const String networkError = 'Please check your internet connection';
  static const String serverError = 'Server error. Please try again later';
  static const String unknownError = 'An unknown error occurred';

  // Success Messages
  static const String loginSuccess = 'Login successful!';
  static const String registerSuccess = 'Registration successful!';
  static const String logoutSuccess = 'Logged out successfully';
}
