import 'package:equatable/equatable.dart';
import 'auth_entities.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? profilePicture;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      address: json['address'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'profilePicture': profilePicture,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? profilePicture,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  String? getProfilePictureUrl() {
    if (profilePicture == null || profilePicture!.isEmpty) {
      return null;
    }
    if (profilePicture!.startsWith('http')) {
      return profilePicture;
    }
    return 'http://192.168.1.100:3000$profilePicture'; // Replace with your IP
  }

  // Convert to AuthEntity
  AuthEntity toAuthEntity() {
    return AuthEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      address: address,
      profilePicture: profilePicture,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, address, profilePicture];
}
