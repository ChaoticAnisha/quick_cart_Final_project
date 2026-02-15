import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import 'auth_viewmodel.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl();
});

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, AsyncValue<User?>>((ref) {
      return ProfileViewModel(ref.read(profileRepositoryProvider), ref);
    });

class ProfileViewModel extends StateNotifier<AsyncValue<User?>> {
  final ProfileRepository _profileRepository;
  final Ref _ref;
  final ImagePicker _imagePicker = ImagePicker();

  ProfileViewModel(this._profileRepository, this._ref)
    : super(const AsyncValue.loading());

  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final user = await _profileRepository.getProfile();
      state = AsyncValue.data(user);

      // Update auth state as well
      _ref.read(authViewModelProvider.notifier).updateUser(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? address,
  }) async {
    try {
      final user = await _profileRepository.updateProfile(
        name: name,
        phone: phone,
        address: address,
      );
      state = AsyncValue.data(user);

      // Update auth state as well
      _ref.read(authViewModelProvider.notifier).updateUser(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> updateProfilePicture({required ImageSource source}) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return;

      final user = await _profileRepository.updateProfilePicture(image);

      state = AsyncValue.data(user);

      // Update auth state as well
      _ref.read(authViewModelProvider.notifier).updateUser(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
