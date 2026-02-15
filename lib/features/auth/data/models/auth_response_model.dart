import 'user_model.dart';

class AuthResponseModel {
  final UserModel user;
  final String token;
  final String? message;

  AuthResponseModel({required this.user, required this.token, this.message});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: UserModel.fromJson(json['user']),
      token: json['token'] ?? '',
      message: json['message'],
    );
  }
}
