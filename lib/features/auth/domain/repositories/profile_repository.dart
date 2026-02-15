import 'package:image_picker/image_picker.dart';
import '../entities/user.dart';

abstract class ProfileRepository {
  Future<User> getProfile();
  Future<User> updateProfile({String? name, String? phone, String? address});
  Future<User> updateProfilePicture(XFile image);
}
