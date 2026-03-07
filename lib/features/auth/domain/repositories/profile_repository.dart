import '../entities/user.dart';

abstract class ProfileRepository {
  Future<User> getProfile();
  Future<User> updateProfile({String? name, String? phone, String? address});
}
