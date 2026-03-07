import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_constants.dart';

class SessionService {
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.keyAccessToken);
  }
}
