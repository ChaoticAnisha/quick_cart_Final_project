import 'package:equatable/equatable.dart';
import 'package:quick_cart/features/auth/domain/entities/user.dart';

class AuthEntity extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? profilePicture;

  const AuthEntity({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [id, name, email, phone, address, profilePicture];

  // Convert to User entity
  toUser() {
    return User(
      id: id ?? '',
      name: name,
      email: email,
      phone: phone,
      address: address,
      profilePicture: profilePicture,
    );
  }
}

