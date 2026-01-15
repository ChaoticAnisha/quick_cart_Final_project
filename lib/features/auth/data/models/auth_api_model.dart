import '../../../../domain/entities/auth_entities.dart';

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
    return AuthApiModel(
      id: json['id'] ?? json['_id'],
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      profilePicture: json['profilePicture'] ?? json['profile_picture'],
      token: json['token'],
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
