import '../../domain/entities/auth_entities.dart';

class AuthApiModel {
  final String? id;
  final String name;
  final String email;
  final String? phone;
  final String? profilePicture;
  final String? token;

  AuthApiModel({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profilePicture,
    this.token,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? json; // handle nested user object

    return AuthApiModel(
      id: user['id'] ?? user['_id'],
      name: user['name'] ?? '', // provide default if null
      email: user['email'] ?? '',
      phone: user['phone'],
      profilePicture: user['profilePicture'] ?? user['profile_picture'],
      token: json['token'], // token is outside user
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profilePicture': profilePicture,
      'token': token,
    };
  }

  // Convert API Model to Entity (for domain layer)
  AuthEntity toEntity() {
    return AuthEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      profilePicture: profilePicture,
    );
  }

  // Create from Entity (when sending to API)
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      profilePicture: entity.profilePicture,
    );
  }
}
