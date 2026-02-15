import 'package:image_picker/image_picker.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/remote/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl({ProfileRemoteDataSource? remoteDataSource})
    : _remoteDataSource = remoteDataSource ?? ProfileRemoteDataSource();

  @override
  Future<User> getProfile() async {
    try {
      final response = await _remoteDataSource.getProfile();
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  @override
  Future<User> updateProfile({
    String? name,
    String? phone,
    String? address,
  }) async {
    try {
      final response = await _remoteDataSource.updateProfile(
        name: name,
        phone: phone,
        address: address,
      );
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<User> updateProfilePicture(XFile image) async {
    try {
      final response = await _remoteDataSource.updateProfilePicture(image);
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update profile picture: $e');
    }
  }
}
