import 'package:hive/hive.dart';
import '../../core/constants/app_boxes.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  late Box<UserModel> _userBox;
  late Box _sessionBox;

  AuthRepositoryImpl() {
    _userBox = Hive.box<UserModel>(AppBoxes.userBox);
    _sessionBox = Hive.box(AppBoxes.sessionBox);
  }

  @override
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Check if user already exists
      final existingUser = _userBox.values.firstWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase(),
        orElse: () => UserModel(
          id: '',
          name: '',
          email: '',
          password: '',
          createdAt: DateTime.now(),
        ),
      );

      if (existingUser.email.isNotEmpty) {
        throw Exception('User with this email already exists');
      }

      // Create new user
      final newUser = UserModel.create(
        name: name,
        email: email,
        password: password,
      );

      // Save user to Hive
      await _userBox.put(newUser.id, newUser);

      // Set session
      await _sessionBox.put('currentUserId', newUser.id);
      await _sessionBox.put('isLoggedIn', true);

      return true;
    } catch (e) {
      print('Sign up error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> login({required String email, required String password}) async {
    try {
      // Find user by email
      final user = _userBox.values.firstWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase(),
        orElse: () => UserModel(
          id: '',
          name: '',
          email: '',
          password: '',
          createdAt: DateTime.now(),
        ),
      );

      if (user.email.isEmpty) {
        throw Exception('User not found');
      }

      if (user.password != password) {
        throw Exception('Invalid password');
      }

      // Set session
      await _sessionBox.put('currentUserId', user.id);
      await _sessionBox.put('isLoggedIn', true);

      return true;
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _sessionBox.delete('currentUserId');
      await _sessionBox.put('isLoggedIn', false);
    } catch (e) {
      print('Logout error: $e');
      rethrow;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final userId = _sessionBox.get('currentUserId');
      if (userId == null) return null;

      return _userBox.get(userId);
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return _sessionBox.get('isLoggedIn', defaultValue: false);
    } catch (e) {
      print('Check logged in error: $e');
      return false;
    }
  }

  @override
  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final user = _userBox.values.firstWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase(),
        orElse: () => UserModel(
          id: '',
          name: '',
          email: '',
          password: '',
          createdAt: DateTime.now(),
        ),
      );

      return user.email.isEmpty ? null : user;
    } catch (e) {
      print('Get user by email error: $e');
      return null;
    }
  }
}



